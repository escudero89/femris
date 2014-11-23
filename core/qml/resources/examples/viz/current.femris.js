var G_CURRENT_DOMAIN = {
  "_comment" : "This file is used to generate the example2 in FEMRIS. You shouldn't try to edit it.",

  "_sideloadNodes" : "These nodes are used to determine in which nodes apply the sideload",
  "sideloadNodes" : [
    [  1,  2,  3  ],
    [  3,  4  ],
    [  4,  5,  6  ],
    [  1,  6  ]
  ],

  "_coordinates" : "The values are [ x-coord y-coord ]",
  "coordinates" : [
    [ -1, -1  ],
    [  0, -1  ],
    [  1, -1  ],
    [  1,  1  ],
    [  0,  1  ],
    [ -1,  1  ]
  ],

  "_elements" : "The values are [ indx-node1 ... indx-nodeN ]",
  "elements" : [
    [   1,  2,  5,  6  ],
    [   2,  3,  4,  5  ]
  ]
}