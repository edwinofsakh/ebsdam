%test exportData

eul = [28.9881 8.80943 17.1015];
exportData(eul, 'euler', 'csv')
exportData(eul, 'euler', 'disp')
exportData(eul, 'euler', 'matlab')

mtr = [...
    0.7174    0.6837    0.1340;
   -0.6952    0.7150    0.0742;
   -0.0450   -0.1464    0.9882;
];

exportData(mtr, 'matrix', 'csv')
exportData(mtr, 'matrix', 'disp')
exportData(mtr, 'matrix', 'matlab')
