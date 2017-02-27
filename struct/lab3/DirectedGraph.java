import java.util.*;
/**
**/
public class DirectedGraph<E extends Edge> {

    int[] nodes;
    List<E>[] MF;
    List<E> EL;
    int noOfNodes;

	public DirectedGraph(int noOfNodes) {
        nodes = new int[noOfNodes+1];
        EL = new ArrayList<E>();
        this.noOfNodes = noOfNodes;
	}

	public void addEdge(E e) {
        EL.add(e);
	}

	public Iterator<E> shortestPath(int from, int to) {
        for(int i = 0; i < nodes.length; i++){
            nodes[i] = 0;
        }

        List<E> dj = djikstra(from,to);
		return dj == null ? null : dj.iterator();

	}
		
	public Iterator<E> minimumSpanningTree() {
		return kruskal().iterator();
	}

  private List<E> kruskal(){

    ArrayList<List<E>> cc = new ArrayList<List<E>>();
    for(int i = 0; i<nodes.length; i++){
      cc.add(new ArrayList<>());
    }    
    PriorityQueue<ComparableEdge> pq = new PriorityQueue<ComparableEdge>();

    for(E e : EL){
      pq.add(new ComparableEdge(e));
    }

    int n = noOfNodes;
    System.out.println(n);
    E temp;
    int nextOcc;
    while(!pq.isEmpty() && n>=1){

      temp = pq.poll().edge;
      System.out.println(pq.isEmpty());
      System.out.println(n);

      List<E> from = cc.get(temp.from);
      List<E> to = cc.get(temp.to);
      
      if(from != to){
        if(from.size()<to.size()){
          // add the elements from to-list to from-list 
          to.addAll(from);
          //set the index at "from" point at same arraylist as "to"
          cc.set(temp.from, to);
          nextOcc = cc.indexOf(from);
          while(nextOcc>0){
            System.out.println(nextOcc);
            cc.set(nextOcc, to);
            nextOcc = cc.indexOf(from);
          }

          to.add(temp);
        }
        else{
          from.addAll(to);
          cc.set(temp.to, from);

          nextOcc = cc.indexOf(to);
          while(nextOcc>0){
            System.out.println(nextOcc);
            cc.set(nextOcc, from);
            nextOcc = cc.indexOf(to);
          }
          from.add(temp);
        }
        n--;
      }
    }
    if(cc.get(0).size() == nodes.length -1){

      return cc.get(0);
    }
    System.out.println(cc.get(0));
      return cc.get(0);
  }


  private class ComparableEdge implements Comparable<ComparableEdge>{
    E edge;

    public ComparableEdge(E edge){
      this.edge = edge;
    }

    public int compareTo(ComparableEdge e){
       if(e.edge.getWeight()>this.edge.getWeight()){
           return -1;
       }
       if(e.edge.getWeight()<this.edge.getWeight()){
           return 1;
       }
       return 0;
     }
  }


  private ArrayList<E> djikstra(int from, int to){

    PriorityQueue<QueueElement> q = new PriorityQueue<QueueElement>();

    ArrayList<E> list = new ArrayList<E>();
    q.add(new QueueElement(from,0, list));

    QueueElement tmpQE;
    while(!q.isEmpty()){
       tmpQE = q.poll();
       if(nodes[tmpQE.to + 1] != -1){
            if(tmpQE.to == to){
                return tmpQE.path;
            } 
            else{
                nodes[tmpQE.to + 1] = -1;

                for(E e: EL){
                    if(e.from == tmpQE.to){
                        if(nodes[e.to + 1] != -1){
                            list = tmpQE.path;
                            list = (ArrayList<E>) list.clone();
                            list.add(e);
                            q.add(new QueueElement(e.to,
                                        tmpQE.cost + e.getWeight(),
                                        list));
                        }
                    }
                }
            }
         }
     }
     return null;
  }


   private class QueueElement implements Comparable<QueueElement>{
     int to;
     double cost;
     ArrayList<E> path;

     QueueElement(int to, double cost, ArrayList<E> path){

         this.to = to;
         this.cost = cost;
         this.path = path;
     }

     public int compareTo(QueueElement q){
         if(q.cost>this.cost){
             return -1;
         }

         if(q.cost<this.cost){
             return 1;
         }
         return 0;
     }
   }

}
  
