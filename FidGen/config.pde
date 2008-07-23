float SCALE=200;
float DRAW_SCALE = 1.4;
float LEAF_SCALE=1.41;

AABB BOUNDS=new AABB(new Vec3D(0,SCALE/2,0),new Vec3D(SCALE/2,SCALE/2,0));

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

boolean newFid=true;
boolean isSaved=true;
boolean isInverted=true;

boolean forceMinimumDistance=false;
boolean showDebug=true;
boolean showPhysics=true;
boolean showDepthSequence=true;
boolean showFiducialID=true;
