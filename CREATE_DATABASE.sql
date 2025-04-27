DROP DATAVERSE LocationDb IF EXISTS;
CREATE DATAVERSE LocationDb;
USE LocationDb;


CREATE TYPE LocationType AS {
    id: bigint,
    location: point,
    description: string
};

CREATE DATASET Locations_RTree_Constant(LocationType) PRIMARY KEY id
WITH {
    "merge-policy": {
        "name": "constant",
        "parameters": { 
            "num-components": 2 
        }
    }
};
CREATE INDEX Location_RTree_Constant_Index on Locations_RTree_Constant(location) TYPE rtree;
CREATE DATASET Locations_RTree_Concurrent(LocationType) PRIMARY KEY id
WITH {
    "merge-policy": {
        "name": "concurrent",
        "parameters": {
            "size-ratio": 1.2, 
            "max-component-count": 10, 
            "min-merge-component-count": 2, 
            "max-merge-component-count": 5
        }
    }
};
CREATE INDEX Locations_RTree_Concurrent_Index on Locations_RTree_Concurrent(location) TYPE rtree;

CREATE DATASET Locations_RTree_CorrelatedPrefix(LocationType) PRIMARY KEY id
WITH {
    "merge-policy": {
        "name": "correlated-prefix",
        "parameters": { 
            "max-mergable-component-size": 16384, 
            "max-tolerance-component-count": 3
        }
    }
};
CREATE INDEX Locations_RTree_CorrelatedPrefix_Index on Locations_RTree_CorrelatedPrefix(location) TYPE rtree;

CREATE DATASET Locations_BTree_Constant(LocationType) PRIMARY KEY id;
CREATE INDEX Locations_BTree_Constant_Index on Locations_BTree_Constant(location) TYPE rtree;

CREATE DATASET Locations_BTree_Concurrent(LocationType) PRIMARY KEY id;
CREATE INDEX Locations_BTree_Concurrent_Index on Locations_BTree_Concurrent(location) TYPE rtree;