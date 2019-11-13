DEPA Assignment 1 OpenRefine Data Cleaning codes
Name: Troy Zhongyi Zhang
Date: 07/10/2019


[
  {
    "op": "core/column-removal",
    "description": "Remove column School Zip",
    "columnName": "School Zip"
  },
  {
    "op": "core/column-removal",
    "description": "Remove column School State",
    "columnName": "School State"
  },
  {
    "op": "core/column-removal",
    "description": "Remove column School Name",
    "columnName": "School Name"
  },
  {
    "op": "core/column-removal",
    "description": "Remove column School Region",
    "columnName": "School Region"
  },
  {
    "op": "core/column-removal",
    "description": "Remove column School Number",
    "columnName": "School Number"
  },
  {
    "op": "core/column-removal",
    "description": "Remove column School Phone Number",
    "columnName": "School Phone Number"
  },
  {
    "op": "core/column-removal",
    "description": "Remove column School Code",
    "columnName": "School Code"
  },
  {
    "op": "core/column-removal",
    "description": "Remove column School Address",
    "columnName": "School Address"
  },
  {
    "op": "core/column-removal",
    "description": "Remove column School City",
    "columnName": "School City"
  },
  {
    "op": "core/column-removal",
    "description": "Remove column Facility Type",
    "columnName": "Facility Type"
  },
  {
    "op": "core/column-removal",
    "description": "Remove column Intersection Street 1",
    "columnName": "Intersection Street 1"
  },
  {
    "op": "core/column-removal",
    "description": "Remove column Intersection Street 2",
    "columnName": "Intersection Street 2"
  },
  {
    "op": "core/column-removal",
    "description": "Remove column Park Facility Name",
    "columnName": "Park Facility Name"
  },
  {
    "op": "core/column-removal",
    "description": "Remove column School Not Found",
    "columnName": "School Not Found"
  },
  {
    "op": "core/text-transform",
    "description": "Text transform on cells in column Incident Address using expression value.trim()",
    "engineConfig": {
      "facets": [],
      "mode": "row-based"
    },
    "columnName": "Incident Address",
    "expression": "value.trim()",
    "onError": "keep-original",
    "repeat": false,
    "repeatCount": 10
  },
  {
    "op": "core/text-transform",
    "description": "Text transform on cells in column Street Name using expression value.trim()",
    "engineConfig": {
      "facets": [],
      "mode": "row-based"
    },
    "columnName": "Street Name",
    "expression": "value.trim()",
    "onError": "keep-original",
    "repeat": false,
    "repeatCount": 10
  },
  {
    "op": "core/text-transform",
    "description": "Text transform on cells in column Cross Street 1 using expression value.trim()",
    "engineConfig": {
      "facets": [],
      "mode": "row-based"
    },
    "columnName": "Cross Street 1",
    "expression": "value.trim()",
    "onError": "keep-original",
    "repeat": false,
    "repeatCount": 10
  },
  {
    "op": "core/text-transform",
    "description": "Text transform on cells in column Cross Street 2 using expression value.trim()",
    "engineConfig": {
      "facets": [],
      "mode": "row-based"
    },
    "columnName": "Cross Street 2",
    "expression": "value.trim()",
    "onError": "keep-original",
    "repeat": false,
    "repeatCount": 10
  },
  {
    "op": "core/text-transform",
    "description": "Text transform on cells in column Street Name using expression value.trim()",
    "engineConfig": {
      "facets": [],
      "mode": "row-based"
    },
    "columnName": "Street Name",
    "expression": "value.trim()",
    "onError": "keep-original",
    "repeat": false,
    "repeatCount": 10
  },
  {
    "op": "core/text-transform",
    "description": "Text transform on cells in column Incident Zip using expression value.trim()",
    "engineConfig": {
      "facets": [],
      "mode": "row-based"
    },
    "columnName": "Incident Zip",
    "expression": "value.trim()",
    "onError": "keep-original",
    "repeat": false,
    "repeatCount": 10
  },
  {
    "op": "core/text-transform",
    "description": "Text transform on cells in column Incident Address using expression value.toTitlecase()",
    "engineConfig": {
      "facets": [],
      "mode": "row-based"
    },
    "columnName": "Incident Address",
    "expression": "value.toTitlecase()",
    "onError": "keep-original",
    "repeat": false,
    "repeatCount": 10
  },
  {
    "op": "core/text-transform",
    "description": "Text transform on cells in column Street Name using expression value.toTitlecase()",
    "engineConfig": {
      "facets": [],
      "mode": "row-based"
    },
    "columnName": "Street Name",
    "expression": "value.toTitlecase()",
    "onError": "keep-original",
    "repeat": false,
    "repeatCount": 10
  },
  {
    "op": "core/text-transform",
    "description": "Text transform on cells in column Cross Street 1 using expression value.toTitlecase()",
    "engineConfig": {
      "facets": [],
      "mode": "row-based"
    },
    "columnName": "Cross Street 1",
    "expression": "value.toTitlecase()",
    "onError": "keep-original",
    "repeat": false,
    "repeatCount": 10
  },
  {
    "op": "core/text-transform",
    "description": "Text transform on cells in column Cross Street 2 using expression value.toTitlecase()",
    "engineConfig": {
      "facets": [],
      "mode": "row-based"
    },
    "columnName": "Cross Street 2",
    "expression": "value.toTitlecase()",
    "onError": "keep-original",
    "repeat": false,
    "repeatCount": 10
  },
  {
    "op": "core/text-transform",
    "description": "Text transform on cells in column City using expression value.toTitlecase()",
    "engineConfig": {
      "facets": [],
      "mode": "row-based"
    },
    "columnName": "City",
    "expression": "value.toTitlecase()",
    "onError": "keep-original",
    "repeat": false,
    "repeatCount": 10
  },
  {
    "op": "core/mass-edit",
    "description": "Mass edit cells in column City",
    "engineConfig": {
      "facets": [],
      "mode": "row-based"
    },
    "columnName": "City",
    "expression": "value",
    "edits": [
      {
        "fromBlank": false,
        "fromError": false,
        "from": [
          "Staten Island",
          "State Island"
        ],
        "to": "Staten Island"
      }
    ]
  },
  {
    "op": "core/mass-edit",
    "description": "Mass edit cells in column Descriptor",
    "engineConfig": {
      "facets": [],
      "mode": "row-based"
    },
    "columnName": "Descriptor",
    "expression": "value",
    "edits": [
      {
        "fromBlank": false,
        "fromError": false,
        "from": [
          "Other Water Problem (Use Comments) (WZZ)",
          "Other Water Problem (Use Comments) (QZZ)"
        ],
        "to": "Other Water Problem"
      },
      {
        "fromBlank": false,
        "fromError": false,
        "from": [
          "Commercial 421A Exemption",
          "Commercial 421B Exemption"
        ],
        "to": "Commercial Exemption"
      }
    ]
  },
  {
    "op": "core/mass-edit",
    "description": "Mass edit cells in column Descriptor",
    "engineConfig": {
      "facets": [],
      "mode": "row-based"
    },
    "columnName": "Descriptor",
    "expression": "value",
    "edits": [
      {
        "fromBlank": false,
        "fromError": false,
        "from": [
          "Personal DRIE Exemption",
          "Personal SCHE Exemption",
          "Personal DHE Exemption"
        ],
        "to": "Personal Exemption"
      },
      {
        "fromBlank": false,
        "fromError": false,
        "from": [
          "Commercial Exemption",
          "Commercial Other Exemption"
        ],
        "to": "Commercial Exemption"
      }
    ]
  },
  {
    "op": "core/mass-edit",
    "description": "Mass edit cells in column Location Type",
    "engineConfig": {
      "facets": [],
      "mode": "row-based"
    },
    "columnName": "Location Type",
    "expression": "value",
    "edits": [
      {
        "fromBlank": false,
        "fromError": false,
        "from": [
          "Store/Commercial",
          "Comercial",
          "Commercial"
        ],
        "to": "Commercial"
      }
    ]
  },
  {
    "op": "core/mass-edit",
    "description": "Mass edit cells in column Location Type",
    "engineConfig": {
      "facets": [],
      "mode": "row-based"
    },
    "columnName": "Location Type",
    "expression": "value",
    "edits": [
      {
        "fromBlank": false,
        "fromError": false,
        "from": [
          "RESIDENTIAL BUILDING",
          "Residential Building"
        ],
        "to": "Residence2"
      }
    ]
  },
  {
    "op": "core/mass-edit",
    "description": "Mass edit cells in column Location Type",
    "engineConfig": {
      "facets": [],
      "mode": "row-based"
    },
    "columnName": "Location Type",
    "expression": "value",
    "edits": [
      {
        "fromBlank": false,
        "fromError": false,
        "from": [
          "Residence2",
          "Residence"
        ],
        "to": "Residential"
      }
    ]
  },
  {
    "op": "core/mass-edit",
    "description": "Mass edit cells in column Location Type",
    "engineConfig": {
      "facets": [],
      "mode": "row-based"
    },
    "columnName": "Location Type",
    "expression": "value",
    "edits": [
      {
        "fromBlank": false,
        "fromError": false,
        "from": [
          "Club/Bar/Restaurant",
          "Bar/Restaurant"
        ],
        "to": "Restaurant2"
      }
    ]
  },
  {
    "op": "core/mass-edit",
    "description": "Mass edit cells in column Location Type",
    "engineConfig": {
      "facets": [],
      "mode": "row-based"
    },
    "columnName": "Location Type",
    "expression": "value",
    "edits": [
      {
        "fromBlank": false,
        "fromError": false,
        "from": [
          "Restaurant2",
          "Restaurant"
        ],
        "to": "Club/Bar/Restaurant"
      }
    ]
  },
  {
    "op": "core/mass-edit",
    "description": "Mass edit cells in column Location Type",
    "engineConfig": {
      "facets": [],
      "mode": "row-based"
    },
    "columnName": "Location Type",
    "expression": "value",
    "edits": [
      {
        "fromBlank": false,
        "fromError": false,
        "from": [
          "3+ Family Apt. Building",
          "3+ Family Apartment Building"
        ],
        "to": "3+ Family Apartment"
      }
    ]
  },
  {
    "op": "core/mass-edit",
    "description": "Mass edit cells in column Location Type",
    "engineConfig": {
      "facets": [],
      "mode": "row-based"
    },
    "columnName": "Location Type",
    "expression": "value",
    "edits": [
      {
        "fromBlank": false,
        "fromError": false,
        "from": [
          "Street/Sidewalk",
          "Street and Sidewalk"
        ],
        "to": "Street/Sidewalk"
      }
    ]
  },
  {
    "op": "core/text-transform",
    "description": "Text transform on cells in column Location using expression value.trim()",
    "engineConfig": {
      "facets": [],
      "mode": "row-based"
    },
    "columnName": "Location",
    "expression": "value.trim()",
    "onError": "keep-original",
    "repeat": false,
    "repeatCount": 10
  },
  {
    "op": "core/text-transform",
    "description": "Text transform on cells in column Location using expression grel:value.replace(\"(\",\"\")",
    "engineConfig": {
      "facets": [],
      "mode": "row-based"
    },
    "columnName": "Location",
    "expression": "grel:value.replace(\"(\",\"\")",
    "onError": "keep-original",
    "repeat": false,
    "repeatCount": 10
  },
  {
    "op": "core/text-transform",
    "description": "Text transform on cells in column Location using expression grel:value.replace(\")\",\"\")",
    "engineConfig": {
      "facets": [],
      "mode": "row-based"
    },
    "columnName": "Location",
    "expression": "grel:value.replace(\")\",\"\")",
    "onError": "keep-original",
    "repeat": false,
    "repeatCount": 10
  },
  {
    "op": "core/column-removal",
    "description": "Remove column School or Citywide Complaint",
    "columnName": "School or Citywide Complaint"
  },
  {
    "op": "core/column-removal",
    "description": "Remove column Vehicle Type",
    "columnName": "Vehicle Type"
  },
  {
    "op": "core/column-removal",
    "description": "Remove column Taxi Company Borough",
    "columnName": "Taxi Company Borough"
  },
  {
    "op": "core/column-removal",
    "description": "Remove column Taxi Pick Up Location",
    "columnName": "Taxi Pick Up Location"
  },
  {
    "op": "core/column-removal",
    "description": "Remove column Bridge Highway Name",
    "columnName": "Bridge Highway Name"
  },
  {
    "op": "core/column-removal",
    "description": "Remove column Bridge Highway Direction",
    "columnName": "Bridge Highway Direction"
  },
  {
    "op": "core/column-removal",
    "description": "Remove column Road Ramp",
    "columnName": "Road Ramp"
  },
  {
    "op": "core/column-removal",
    "description": "Remove column Bridge Highway Segment",
    "columnName": "Bridge Highway Segment"
  },
  {
    "op": "core/column-removal",
    "description": "Remove column Garage Lot Name",
    "columnName": "Garage Lot Name"
  },
  {
    "op": "core/column-removal",
    "description": "Remove column Ferry Direction",
    "columnName": "Ferry Direction"
  },
  {
    "op": "core/column-removal",
    "description": "Remove column Ferry Terminal Name",
    "columnName": "Ferry Terminal Name"
  },
  {
    "op": "core/column-removal",
    "description": "Remove column Landmark",
    "columnName": "Landmark"
  }
]