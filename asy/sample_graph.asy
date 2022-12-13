import graph;

settings.tex = "pdflatex";

void node_decorator(pair pos, string, pen, pen) {
    filldraw(circle(pos + graph.node_size*(0.7,0.7), graph.node_size*0.2), white, black+1);
}

graph.draw(new pair[]{(0,0), (1,1), (2,0)}, node_background = new pen[]{red}, new int[][]{{0,1},{1,2},{2,0}}, node_decorator);
