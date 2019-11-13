/*
 * Copyright DataStax, Inc.
 *
 * Please see the included license file for details.
 */

package com.datastax.dse.demos.solr.probes;

public interface IndexingLatencyProbe
{
    void maybeProbe(String id, long startNanos);
}
