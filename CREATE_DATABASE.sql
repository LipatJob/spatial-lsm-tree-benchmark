DROP DATAVERSE LocationDb IF EXISTS;
CREATE DATAVERSE LocationDb;
USE LocationDb;


CREATE TYPE LocationType AS {
    id: bigint,
    location: point,
    description: string
};

CREATE DATASET Locations_RTree_Constant(LocationType) PRIMARY KEY id;
CREATE INDEX Location_RTree_Constant_Index on Locations_RTree_Constant(location) TYPE rtree;

CREATE DATASET Locations_RTree_Concurrent(LocationType) PRIMARY KEY id;
CREATE INDEX Locations_RTree_Concurrent_Index on Locations_RTree_Concurrent(location) TYPE rtree;

CREATE DATASET Locations_BTree_Constant(LocationType) PRIMARY KEY id;
CREATE INDEX Locations_BTree_Constant_Index on Locations_BTree_Constant(location) TYPE rtree;

CREATE DATASET Locations_BTree_Concurrent(LocationType) PRIMARY KEY id;
CREATE INDEX Locations_BTree_Concurrent_Index on Locations_BTree_Concurrent(location) TYPE rtree;