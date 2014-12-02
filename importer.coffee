######################## Import actors ########################
Actor = require './models/actor'

# Send a post request to get the actors data.
actorsJsonData = '{"__actors__": [[1, "Wilhelm C. Rontgen"], [2, "Hendrik A. Lorentz"], [3, "Pieter Zeeman"], [4, "Antoine Henri Becquerel"], [5, "Pierre Curie"], [6, "Marie Curie"], [7, "John W. Strutt"], [8, "Philipp E. A. von Lenard"], [9, "Sir Joseph J. Thomson"], [10, "Albert A. Michelson"], [11, "Gabriel Lippmann"], [12, "Carl F. Braun"], [13, "Guglielmo Marconi"], [14, "Johannes D. van der Waals"], [15, "Wilhelm Wien"], [16, "Nils G. Dalen"], [17, "Heike Kamerlingh Onnes"], [18, "Max von Laue"], [19, "Sir William H. Bragg"], [20, "Sir William L. Bragg"], [21, "Charles G. Barkla"], [22, "Max K. E. L. Planck"], [23, "Johannes Stark"], [24, "Charles E. Guillaume"], [25, "Albert Einstein"], [26, "Niels Bohr"], [27, "Robert A. Millikan"], [28, "Karl M. G. Siegbahn"], [29, "James Franck"], [30, "Gustav Hertz"], [31, "Jean B. Perrin"], [32, "Arthur H. Compton"], [33, "Charles T. R. Wilson"], [34, "Owen W. Richardson"], [35, "Prince Louis-Victor de Broglie"], [36, "Sir Chandrasekhara V. Raman"], [37, "Werner Heisenberg"], [38, "Paul A. M. Dirac"], [39, "Erwin Schrodinger"], [40, "Sir James Chadwick"], [41, "Carl D. Anderson"], [42, "Victor F. Hess"], [43, "Clinton J. Davisson"], [44, "Sir George P. Thomson"], [45, "Enrico Fermi"], [46, "Ernest O. Lawrence"], [47, "Otto Stern"], [48, "Isidor Isaac Rabi"], [49, "Wolfgang Pauli"], [50, "Percy W. Bridgman"], [51, "Sir Edward V. Appleton"], [52, "Patrick M. S. Blackett"], [53, "Hideki Yukawa"], [54, "Cecil F. Powell"], [55, "Adam"], [56, "Maria Sharapova"], [57, "Petra Kvitova"], [58, "Ana Ivanovic"], [59, "Li Na"], [60, "Simona Halep"]]}'

# Process the actors data.
actorsData = JSON.parse actorsJsonData
for actor in actorsData.__actors__
  Actor.createNewActor actor[0], actor[1], (err, actor) ->
    if error?
      console.log 'Error while creating actor ' + actor + ': ' + err


######################## Import stages ########################
Stage = require './models/stage'

# Send a post request to get the actors data.
stagesJsonData = '{"__stages__": [[1, "Lab", "Victors lab"], [2, "Living Room", "Victors home"], [3, "Monsters memory", "Monster is telling his story"], [4, "Forest", "Where murder happens"], [5, "general", "general stage"]]}'

# Process the actors data.
stagesData = JSON.parse stagesJsonData
for stage in stagesData.__stages__
  Stage.createNewStage stage[0], stage[1], (err, stage) ->
    if error?
      console.log 'Error while creating stage ' + stage + ': ' + err
