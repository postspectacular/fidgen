String CONFIG_PATH="config/fidgen.properties";

float SCALE=200;
float DRAW_SCALE = 1.4;
float LEAF_SCALE=1.41;

int NODE_DIAMETER=15;
int NUM_NODES=22;
int MIN_BLACK_NODES=4;
int MAX_BLACK_NODES=7;
int MAX_NODES_IN_CLUSTER = 10;
int MAX_DEPTHSEQ_LENGTH = 28;
int MAX_CIRCLE_RADIUS=13;

float CLUSTER_DIST_FACTOR = 5.25;
float CLUSTER_DIST = NODE_DIAMETER * CLUSTER_DIST_FACTOR;
float CLUSTER_STRENGTH = 0.05;
float MIN_ORIENT_LEN = 0.75;

int MAX_ITERATIONS = 200;
int NUM_DIGITS=4;

boolean newFid=true;
boolean isSaved=true;
boolean isInverted=true;

boolean forceMinimumDistance=false;
boolean showDebug=true;
boolean showPhysics=true;
boolean showDepthSequence=true;
boolean showFiducialID=true;

void initConfig() {
  if (config==null) {
    config=new TypedProperties();
    try {
      config.load(openStream(sketchPath(CONFIG_PATH)));
      overwriteDefaults();
    }
    catch (Exception e) {
      println("error opening config file ("+CONFIG_PATH+"). using defaults...");
    }
  }
}

void overwriteDefaults() {
  SCALE=config.getFloat("nodes.scale",SCALE);
  DRAW_SCALE=config.getFloat("ui.render.scale",DRAW_SCALE);
  LEAF_SCALE=config.getFloat("ui.render.leaf.scale",LEAF_SCALE);

  NODE_DIAMETER=config.getInt("nodes.diameter",NODE_DIAMETER);
  NUM_NODES=config.getInt("nodes.count",NUM_NODES);
  MIN_BLACK_NODES=config.getInt("nodes.black.mincount",MIN_BLACK_NODES);
  MAX_BLACK_NODES=config.getInt("nodes.black.maxcount",MAX_BLACK_NODES);
  MAX_NODES_IN_CLUSTER=config.getInt("nodes.cluster.maxcount",MAX_NODES_IN_CLUSTER);
  MAX_DEPTHSEQ_LENGTH=config.getInt("tree.sequence.maxlength",MAX_DEPTHSEQ_LENGTH);
  MAX_CIRCLE_RADIUS=config.getInt("nodes.radius",MAX_CIRCLE_RADIUS);

  CLUSTER_DIST_FACTOR=config.getFloat("nodes.cluster.distfactor",CLUSTER_DIST_FACTOR);
  CLUSTER_DIST = NODE_DIAMETER * CLUSTER_DIST_FACTOR;
  CLUSTER_STRENGTH=config.getFloat("nodes.cluster.strength",CLUSTER_STRENGTH);
  
  MIN_ORIENT_LEN=config.getFloat("generator.orientation.minlength",MIN_ORIENT_LEN);
  MAX_ITERATIONS=config.getInt("generator.iterations.max",MAX_ITERATIONS);

  NUM_DIGITS=config.getInt("generator.label.numdigits",NUM_DIGITS);
  
  BOUNDS=new AABB(new Vec3D(0,SCALE/2,0),new Vec3D(SCALE/2,SCALE/2,0));
}
