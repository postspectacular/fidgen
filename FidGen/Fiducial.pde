class FiducialNode extends VerletParticle {
  int level;
  Vec3D pos;
  Vec3D centre;

  Vec3D avgBlack, avgAll;

  int numBlack;

  FiducialNode parent;

  ArrayList children;
  ArrayList blacks;
  ArrayList nodes;
  ArrayList clusterSizes;

  public FiducialNode(FiducialNode p, int numChildren, Vec3D c, Vec3D pos) {
    super(pos);
    parent=p;
    if (p!=null) level=p.level+1;
    centre=c;
    if (numChildren>0) {
      physics.addParticle(this);
      children=new ArrayList();
      blacks=new ArrayList();
      nodes=new ArrayList();
      clusterSizes=new ArrayList();
      if (parent==null) {
        // root
        this.lock();
        numBlack=(int)random(MIN_BLACK_NODES,MAX_BLACK_NODES);
        VerletParticle blackCentre=new VerletParticle(0,-SCALE*0.33,0);
        AABB blackBounds=new AABB(blackCentre,new Vec3D(SCALE*0.5,SCALE*0.13,0));
        physics.addParticle(blackCentre);
        blackCentre.lock();
        for(int i=0; i<numBlack; i++) {
          FiducialNode f=new FiducialNode(this,0,blackCentre,blackCentre.add(random(-1,1)*SCALE,random(-1,1)*SCALE*0.25,0));
          f.bounds=blackBounds;
          children.add(f);
          blacks.add(f);
          nodes.add(f);
          clusterSizes.add(new Integer(0));
          physics.addParticle(f);
          physics.addSpring(new VerletSpring(blackCentre,f,0,0.01));
          if (i>0) {
            for(int j=0; j<i; j++) {
              physics.addSpring(new VerletSpring((VerletParticle)children.get(j),f,NODE_DIAMETER*17,0.01));
            }
          }
        }
        int nodesLeft=numChildren-numBlack;
        ArrayList clusters=new ArrayList();
        while(nodesLeft>0) {
          int nodes=(int)random(1,PApplet.constrain(nodesLeft,1,MAX_NODES_IN_CLUSTER));
          //println("white: "+nodes);
          FiducialNode f=new FiducialNode(this,nodes,new Vec3D(), new Vec3D(random(-1,1)*SCALE*0.25, random(0.5,1)*SCALE*0.5, 0));
          f.bounds=BOUNDS;
          clusters.add(f);
          children.add(f);
          clusterSizes.add(new Integer(nodes));
          nodesLeft-=nodes;
        }

        // connect all nodes to push apart
        Iterator i=children.iterator();
        while(i.hasNext()) {
          FiducialNode f=(FiducialNode)i.next();
          f.cluster(clusters);
        }
      } 
      else {
        // branch
        float minDist=NODE_DIAMETER*(2+numChildren*0.33);
        FiducialNode root=getRoot();
        for(int i=0; i<numChildren; i++) {
          FiducialNode f=new FiducialNode(this,0,centre,centre.add(random(-1,1)*SCALE*0.5,random(0,1)*SCALE*0.5,0));
          f.bounds=BOUNDS;
          children.add(f);
          root.nodes.add(f);
          if (i>0) {
            for(int j=0; j<i; j++) {
              physics.addSpring(new VerletSpring((VerletParticle)children.get(j),f,minDist,0.01));
            }
          }
        }
      }
    }
  }

  FiducialNode getRoot() {
    if (parent==null) return this;
    else return parent.getRoot();
  }

  String toString() {
    Collections.sort(clusterSizes);
    Collections.reverse(clusterSizes);
    StringBuffer sb=new StringBuffer();
    sb.append("0");
    Iterator i=clusterSizes.iterator();
    while(i.hasNext()) {
      sb.append("1");
      int count=((Integer)i.next()).intValue();
      if (count>0) for(int idx=1; idx<=count; idx++) sb.append("2");
    }
    return sb.toString();
  }

  void cluster(ArrayList siblings) {
    if (children!=null) {
      Iterator i=children.iterator();
      while(i.hasNext()) {
        FiducialNode f=(FiducialNode)i.next();
        Iterator j=siblings.iterator();
        while(j.hasNext()) {
          FiducialNode s=(FiducialNode)j.next();
          if (s.children!=null) {
            Iterator k=s.children.iterator();
            while(k.hasNext()) {
              FiducialNode c=(FiducialNode)k.next();
              physics.addSpring(new VerletMinDistanceSpring(f,c,CLUSTER_DIST,CLUSTER_STRENGTH));
            }
          } 
          else {
            physics.addSpring(new VerletMinDistanceSpring(f,s,CLUSTER_DIST,CLUSTER_STRENGTH));
          }
        }
      }
    } 
    else {
      Iterator j=siblings.iterator();
      while(j.hasNext()) {
        FiducialNode s=(FiducialNode)j.next();
        if (s.children!=null) {
          Iterator k=s.children.iterator();
          while(k.hasNext()) {
            FiducialNode c=(FiducialNode)k.next();
            physics.addSpring(new VerletMinDistanceSpring(this,c,CLUSTER_DIST,CLUSTER_STRENGTH));
          }
        } 
        else {
          physics.addSpring(new VerletMinDistanceSpring(this,s,CLUSTER_DIST,CLUSTER_STRENGTH));
        }
      }
    }
  }

  void update() {
    avgBlack=new Vec3D();
    Iterator i=blacks.iterator();
    while(i.hasNext()) {
      avgBlack.addSelf((FiducialNode)i.next());
    }
    avgBlack.scaleSelf(1.0/blacks.size());

    avgAll=new Vec3D();
    i=nodes.iterator();
    while(i.hasNext()) {
      avgAll.addSelf((FiducialNode)i.next());
    }
    avgAll.scaleSelf(1.0/nodes.size());
  }

  void draw() {
    int[] sizes=new int[]{
      MAX_CIRCLE_RADIUS,MAX_CIRCLE_RADIUS-3,4,1
    };
    boolean isBlack=true;
    for(int i=0; i<sizes.length; i++) {
      Iterator c=children.iterator();
      while(c.hasNext()) {
        FiducialNode f=(FiducialNode)c.next();
        f.drawSize(sizes[i],isBlack,i==0);
      }
      isBlack=!isBlack;
    }
  }

  void drawSize(int s, boolean isBlack, boolean isOutline) {
    if (children!=null) {
      Iterator i=children.iterator();
      Vec3D avg=new Vec3D();
      while(i.hasNext()) {
        FiducialNode f=(FiducialNode)i.next();
        f.drawSize(s, isBlack, isOutline);
        avg.addSelf(f);
      }
      if (isBlack && s==4) {
        avg.scaleSelf(1.0/children.size());
        int d=NODE_DIAMETER*s;
        if (!isInverted) {
          fill(isBlack ? 0 : 255);
        } 
        else {
          fill(isBlack ? 255 : 0);
        }
        ellipse(avg.x,avg.y,d,d);
      }
    } 
    else {
      int d;
      if (s>1) {
        if (level==1 && isBlack && !isOutline) return;
        d=NODE_DIAMETER*s;
      } 
      else {
        d=(int)(NODE_DIAMETER*LEAF_SCALE);
        if (level==1) {
          isBlack=true;
        }
      }
      if (!isInverted) {
        fill(isBlack ? 0 : 255);
      } 
      else {
        fill(isBlack ? 255 : 0);
      }
      ellipse(x,y,d,d);
      if (s>1 && !isBlack) {
        Vec3D v=this.interpolateTo(getRoot().avgAll,0.5);
        ellipse(v.x,v.y,d,d);
      }
    }
  }

  public AABB getBounds() {
    return getBounds(null,null);
  }
  
  public AABB getBounds(Vec3D min, Vec3D max) {
    if (min==null) {
      min=new Vec3D();
      max=new Vec3D();
    }
    if (children!=null) {
      Iterator c=children.iterator();
      while(c.hasNext()) {
        FiducialNode f=(FiducialNode)c.next();
        f.getBounds(min,max);
      }
    } 
    else {
      float d=NODE_DIAMETER*MAX_CIRCLE_RADIUS/2;
      min.minSelf(this.sub(d,d,0));
      max.maxSelf(this.add(d,d,0));
    }
    return new AABB(min.interpolateTo(max,0.5), max.sub(min).scaleSelf(0.5));
  }
}
