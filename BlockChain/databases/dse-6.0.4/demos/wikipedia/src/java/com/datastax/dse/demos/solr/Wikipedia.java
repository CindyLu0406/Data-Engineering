/**
 * Copyright DataStax, Inc.
 *
 * Please see the included license file for details.
 */
package com.datastax.dse.demos.solr;

import java.net.InetAddress;
import java.util.Arrays;
import java.util.Properties;

import com.datastax.bdp.config.ClientConfiguration;
import com.datastax.bdp.config.ClientConfigurationBuilder;
import com.datastax.bdp.config.ClientConfigurationFactory;
import com.datastax.bdp.util.DseConnectionUtil;
import com.datastax.driver.core.BoundStatement;
import com.datastax.driver.core.Cluster;
import com.datastax.driver.core.ConsistencyLevel;
import com.datastax.driver.core.Session;
import org.apache.lucene.benchmark.byTask.feeds.DocData;
import org.apache.lucene.benchmark.byTask.feeds.EnwikiContentSource;
import org.apache.lucene.benchmark.byTask.feeds.NoMoreDataException;
import org.apache.lucene.benchmark.byTask.utils.Config;

public class Wikipedia
{
    static String wikifile;
    static String host = "localhost";
    static int port = 9042;
    static String user;
    static String password;
    static EnwikiContentSource source;
    static int limit = Integer.MAX_VALUE;
    
    static Cluster cluster;
    static Session javaDriverSession;
    static BoundStatement bstmt;

    public static void indexWikipedia()
    {
        try
        {
            Properties p = new Properties();
            p.setProperty("keep.image.only.docs", "false");
            p.setProperty("docs.file", wikifile);

            Config config = new Config(p);

            source = new EnwikiContentSource();
            source.setConfig(config);
            source.resetInputs();
            
            DocData docData = new DocData();
            String firstName = null;
            int i = 0;
            for (int x = 0; x < limit; x++)
            {
                if (i > 0 && i % 1000 == 0)
                    System.out.println("Indexed " + i++);

                docData = source.getNextDocData(docData);

                if (firstName == null)
                    firstName = docData.getName();
                else if (firstName.equals(docData.getName()))
                    break; //looped

                if (addDoc(docData))
                {
                    i++;
                }
            }
        }
        catch (NoMoreDataException e)
        {
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
        finally
        {
            try
            {
                source.close();
            }
            catch (Throwable t)
            {

            }
        }

    }

    public static boolean addDoc(DocData d)
    {

        if (d.getTitle().indexOf(":") > 0)
            return false;

        bstmt.bind(d.getName(), d.getTitle(), d.getBody(), d.getDate());
        javaDriverSession.execute(bstmt);

        return true;
    }

    public static void usage()
    {
        System.err.println("usage: wikipedia_import --wikifile [filepath] --limit X");
        System.err.println("see set-solr-options.sh for additional options running against secure DSE");
        System.exit(1);
    }

    public static void main(String[] args)
    {

        if (args.length == 0)
            usage();

        System.out.println("args: " + Arrays.asList(args));

        // parse args
        for (int i = 0; i < args.length; i = i + 2)
        {

            if (args[i].startsWith("--"))
            {
                try
                {
                    String arg = args[i].substring(2);
                    String value = args[i + 1];

                    if (arg.equalsIgnoreCase("wikifile"))
                        wikifile = value;
                    if (arg.equalsIgnoreCase("limit"))
                        limit = Integer.parseInt(value);
                    if (arg.equalsIgnoreCase("host"))
                        host = value;
                    if (arg.equalsIgnoreCase("port"))
                        port= Integer.parseInt(value);
                    if (arg.equalsIgnoreCase("user"))
                        user = value;
                    if (arg.equalsIgnoreCase("password"))
                        password = value;
                }
                catch (Throwable t)
                {
                    usage();
                }
            }
        }
        
        try
        {
            ClientConfiguration clientConfig = ClientConfigurationFactory.getYamlClientConfiguration();
            ClientConfigurationBuilder clientConfigBuilder = new ClientConfigurationBuilder(clientConfig);
            clientConfigBuilder.withCassandraHost(InetAddress.getByName(host));
            clientConfigBuilder.withNativePort(port);
            
            cluster = DseConnectionUtil.createWhitelistingCluster(clientConfigBuilder.build(), user, password);
            javaDriverSession = cluster.connect();
            bstmt = new BoundStatement(javaDriverSession.prepare("INSERT INTO WIKI.SOLR (id, title, body, date) VALUES (?, ?, ?, ?)"));
            bstmt.setConsistencyLevel(ConsistencyLevel.QUORUM);
        }
        catch (Exception e)
        {
            System.out.println("Fatal error when initializing client, exiting");
            e.printStackTrace();
            System.exit(1);
        }

        System.out.println("Start indexing wikipedia...");
        indexWikipedia();
        javaDriverSession.close();
        cluster.close();
        System.out.println("Finished");
        System.exit(0);
    }
}
