var G_CURRENT_DOMAIN = {
  "_comment" : "This file is used to generate the example1 in FEMRIS. You shouldn't try to edit it.",

  "_sideloadNodes" : "These nodes are used to determine in which nodes apply the sideload",
  "sideloadNodes" : [
    [  1,  2,  3,  4  ],
    [  4,  8  ],
    [  6,  7,  8  ],
    [  6, 10  ],
    [ 10, 11, 12  ],
    [ 12, 16  ],
    [ 13, 14, 15, 16  ],
    [  1,  5,  9, 13  ]
  ],

  "_coordinates" : "The values are [ x-coord y-coord ]",
  "coordinates" : [
    [  0,  0  ],
    [  1,  0  ],
    [  2,  0  ],
    [  3,  0  ],
    [  0,  1  ],
    [  1,  1  ],
    [  2,  1  ],
    [  3,  1  ],
    [  0,  2  ],
    [  1,  2  ],
    [  2,  2  ],
    [  3,  2  ],
    [  0,  3  ],
    [  1,  3  ],
    [  2,  3  ],
    [  3,  3  ]
  ],
  "_elements" : "The values are [ indx-node1 ... indx-nodeN ]",
  "elements" : [
    [   1,  5,  6,  2  ],
    [   2,  6,  7,  3  ],
    [   3,  7,  8,  4  ],
    [   5,  9, 10,  6  ],
    [   9, 13, 14, 10  ],
    [  10, 14, 15, 11  ],
    [  11, 15, 16, 12  ]
  ]
}
