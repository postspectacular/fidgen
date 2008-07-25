ControlP5 ui;

void initUI() {
  logoBlack=loadImage("fidgen_b.png");
  logoWhite=loadImage("fidgen_w.png");
  txtFont=loadFont(config.getProperty("ui.font.info","Georgia-14.vlw"));
  fidFont=loadFont(config.getProperty("ui.font.fiducial","Typ1451Bold-24.vlw"));
  int gap=20;
  int right=width-gap;
  int bottom=height-gap;
  ui=new ControlP5(this);
  ui.setColorForeground(0xff808080);
  ui.setColorBackground(0xff666666);
  ui.setColorActive(0xffffff00);
  ui.addToggle("isInverted",isInverted,gap,gap,20,20).setLabel("inverted");
  ui.addToggle("showFiducialID",showFiducialID,gap,60,20,20).setLabel("display fiducial id");
  ui.addToggle("showDepthSequence",showDepthSequence,gap,100,20,20).setLabel("display depth sequence");
  ui.addToggle("showPhysics",showPhysics,gap,180,20,20).setLabel("display physics");
  ui.addToggle("showDebug",showDebug,gap,220,20,20).setLabel("debug marker");

  ui.addSlider("onChangeNodeCount",6,30,NUM_NODES,gap+200,gap,100,20).setLabel("total nodes");
  ui.addSlider("onChangeClusterCount",3,11,MAX_NODES_IN_CLUSTER,gap+200,gap+40,100,20).setLabel("nodes in cluster");
  ui.addSlider("onChangeMinBlackCount",2,7,MIN_BLACK_NODES,gap+400,gap,100,20).setLabel("min black nodes");
  ui.addSlider("onChangeMaxBlackCount",2,7,MAX_BLACK_NODES,gap+400,gap+40,100,20).setLabel("max black nodes");
  ui.addSlider("onChangeClusterDistance",4.85,8,CLUSTER_DIST_FACTOR,gap+600,gap,100,20).setLabel("cluster distance");
  
  ui.addSlider("onChangeMinOrientDistance",0.7,0.9,MIN_ORIENT_LEN,gap+600,gap+40,100,20).setLabel("min arrow length");
  ui.addToggle("forceMinimumDistance",forceMinimumDistance,gap+800,gap+40,20,20).setLabel("force arrow length");

  ui.addButton("acceptMarker",0,right-100,bottom-20,100,20).setLabel("accept");
  ui.addButton("discardMarker",0,right-100,bottom-50,100,20).setLabel("discard");
  ui.addButton("saveTrees",0,right-100,bottom-90,100,20).setLabel("save tree file");
  ui.addButton("newSession",0,right-100,bottom-120,100,20).setLabel("new session");
  ui.setColorLabel(0xffcccccc);
  ui.setColorValue(0xff000000);
}

void onChangeNodeCount(int num) {
  NUM_NODES=num;
  newSession();
}

void onChangeClusterCount(int num) {
  MAX_NODES_IN_CLUSTER=num;
  newSession();
}

void onChangeMinBlackCount(int num) {
  MIN_BLACK_NODES=num;
  newSession();
}

void onChangeMaxBlackCount(int num) {
  MAX_BLACK_NODES=num;
  newSession();
}

void onChangeClusterDistance(float num) {
  CLUSTER_DIST_FACTOR=num;
  CLUSTER_DIST = NODE_DIAMETER * CLUSTER_DIST_FACTOR;
  newSession();
}

void onChangeMinOrientDistance(float num) {
  MIN_ORIENT_LEN=num;
}
