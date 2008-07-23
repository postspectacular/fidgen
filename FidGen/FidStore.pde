class FiducialStore {
  HashMap uniqueFiducials=new HashMap();
  ArrayList orderedFiducials=new ArrayList();

  String lastID=null;

  int startID=0;
  
  FiducialStore() {
    println("creating FidStore...");
  }

  void clear() {
    uniqueFiducials.clear();
    orderedFiducials.clear();
    lastID=null;
    startID=0;
  }
  
  void load(String fn) {
    String[] trees=loadStrings(fn);
    FiducialNode dummy=new FiducialNode(null,NUM_NODES, new Vec3D(), new Vec3D());
    for(int i=0; i<trees.length; i++) {
      String id=trees[i];
      if (id.charAt(0)=='b' || id.charAt(0)=='w') id=id.substring(1);
      println("adding tree: "+id);
      if (isNewUnique(id)) uniqueFiducials.put(id,dummy);
      else {
        println("duplicate id loaded: "+id);
        System.exit(0);
      }
    }
    startID+=trees.length;
    println("session start ID: "+startID);
  }
  
  boolean isNewUnique(String id) {
    return uniqueFiducials.get(id)==null;
  }

  void push(FiducialNode f) {
    String id=f.toString();
    if (isNewUnique(id)) {
      uniqueFiducials.put(id,f);
      orderedFiducials.add(f);
      lastID=id;
      println("added new fiducial, this session: "+orderedFiducials.size()+" total: "+uniqueFiducials.size());
    } 
    else {
      println("id already existing, not added to store");
    }
  }

  boolean pop() {
    FiducialNode f=(FiducialNode)uniqueFiducials.remove(lastID);
    if (f!=null) {
      orderedFiducials.remove(f);
      return true;
    } 
    else return false;
  }

  int sessionSize() {
    return orderedFiducials.size();
  }
  
  int totalSize() {
    return uniqueFiducials.size();
  }
  
  void save() {
    String[] trees=new String[orderedFiducials.size()];
    Iterator i=orderedFiducials.iterator();
    int idx=0;
    while(i.hasNext()) {
      trees[idx++]=(isInverted ? "b" : "w")+i.next().toString();
    }
    String fn=SAVE_NAME+"/"+SAVE_NAME+"_session"+startID+"-"+(startID+sessionSize()-1)+".trees";
    saveStrings(fn,trees);
    println(fn+" written...");
  }
}
