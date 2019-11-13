/*
 * Copyright DataStax, Inc.
 *
 * Please see the included license file for details.
 */

package com.datastax.dse.demos.solr.load;

import com.datastax.dse.demos.solr.CommandLine;
import com.datastax.dse.demos.solr.probes.IndexingLatencyProbe;
import com.datastax.dse.demos.solr.stats.Metrics;

public abstract class LoadStrategy
{
    protected final CommandLine.Params params;
    protected final Metrics metrics;
    protected final InputLoader reader;
    protected final IndexingLatencyProbe indexingLatencyProbe;


    protected LoadStrategy(CommandLine.Params params, Metrics metrics, InputLoader reader, IndexingLatencyProbe indexingLatencyProbe)
    {
        this.params = params;
        this.metrics = metrics;
        this.reader = reader;
        this.indexingLatencyProbe = indexingLatencyProbe;
    }

    public abstract void execute();
}
