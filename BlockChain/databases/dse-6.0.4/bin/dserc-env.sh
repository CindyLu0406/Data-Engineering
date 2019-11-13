#!/bin/sh

############################################
# Pull in DSERC_FILE if it exists
# and extract the credentials
############################################
HADOOP_CREDENTIALS=""
DSE_CLIENT_TOOL_CREDENTIALS=""
DSETOOL_CREDENTIALS=""
if [ -z "$DSERC_FILE" ]; then
    DSERC_FILE="$HOME/.dserc"
fi

read_password()
{
    stty -echo
    trap "stty echo; kill -9 $$" INT
    read "$@"
    stty echo
    trap - INT
    echo
}

set_credentials() {
    if [ -z $DSE_CREDENTIALS_SUPPLIED ]; then
        if [ -f "$DSERC_FILE" ]; then
            username=$(echo `cat $DSERC_FILE | grep -E ^username` | awk  '{ string=substr($0, index($0, "=") + 1); print string; }' )
            password=$(echo `cat $DSERC_FILE | grep -E ^password` | awk  '{ string=substr($0, index($0, "=") + 1); print string; }' )
            sasl_protocol=$(echo `cat $DSERC_FILE | grep -E ^sasl_protocol` | awk  '{ string=substr($0, index($0, "=") + 1); print string; }' )
            login_config=$(echo `cat $DSERC_FILE | grep -E ^login_config` | awk  '{ string=substr($0, index($0, "=") + 1); print string; }' )

            DSE_USERNAME="${username:-$DSE_USERNAME}"
            DSE_PASSWORD="${password:-$DSE_PASSWORD}"
            DSE_SASL_PROTOCOL="${sasl_protocol:-$DSE_SASL_PROTOCOL}"
            DSE_LOGIN_CONFIG="${login_config:-$DSE_LOGIN_CONFIG}"
        fi
        if [ ! -z $dse_username ]; then
            DSE_USERNAME="$dse_username"
            if [ -z $dse_password ]; then
                printf "Password: "
                read_password dse_password
                export dse_password
            fi
            DSE_PASSWORD="$dse_password"
        fi
        if [ ! -z $DSE_USERNAME ]; then
            export HADOOP_CREDENTIALS="-Dcassandra.username=$DSE_USERNAME -Dcassandra.password=$DSE_PASSWORD -Dcom.datastax.bdp.fs.client.authentication.basic.username=$DSE_USERNAME -Dcom.datastax.bdp.fs.client.authentication.basic.password=$DSE_PASSWORD"
            export DSE_CLIENT_TOOL_CREDENTIALS="-u $DSE_USERNAME -p $DSE_PASSWORD"
            export DSETOOL_CREDENTIALS="-l $DSE_USERNAME -p $DSE_PASSWORD"
        fi
    fi
    if [ ! -z $dse_jmx_username ]; then
        DSE_JMX_USERNAME="$dse_jmx_username"
        if [ -z $dse_jmx_password ]; then
            printf "JMX Password: "
            read_password dse_jmx_password
            export dse_jmx_password
        fi
        DSE_JMX_PASSWORD="$dse_jmx_password"
    elif [ -f "$DSERC_FILE" ]; then
        DSE_JMX_USERNAME=$(echo `cat $DSERC_FILE | grep -E ^jmx_username` | awk  '{ string=substr($0, index($0, "=") + 1); print string; }' )
        DSE_JMX_PASSWORD=$(echo `cat $DSERC_FILE | grep -E ^jmx_password` | awk  '{ string=substr($0, index($0, "=") + 1); print string; }' )
    fi
    if [ ! -z $DSE_JMX_USERNAME ]; then
        DSE_JMX_CREDENTIALS="-a $DSE_JMX_USERNAME -b $DSE_JMX_PASSWORD"
        CASSANDRA_JMX_CREDENTIALS="-u $DSE_JMX_USERNAME -pw $DSE_JMX_PASSWORD"
    fi

    if [ -z "$DSE_USERNAME" ]; then
        unset DSE_USERNAME
    else
        export DSE_USERNAME
    fi

    if [ -z "$DSE_PASSWORD" ]; then
        unset DSE_PASSWORD
    else
        export DSE_PASSWORD
    fi

    if [ -z "$DSE_SASL_PROTOCOL" ]; then
        unset DSE_SASL_PROTOCOL
    else
        export DSE_SASL_PROTOCOL
    fi
}

set_credentials
