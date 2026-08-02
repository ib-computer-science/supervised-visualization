import supervised_common;
setColorScheme(black, white);  // this exercise is printed black-on-white

// --- Tree node structure (same shape as supervised_tree.asy)
struct TreeNode {
    string label;    // split condition (internal nodes)
    bool isLeaf;
    int leafClass;   // 1 or 2 (leaves only)
    string edgeLbl;  // label on the incoming edge from parent
    TreeNode left;
    TreeNode right;
}

TreeNode internal(string lbl, string edgeLbl, TreeNode left, TreeNode right) {
    TreeNode n = new TreeNode;
    n.label   = lbl;
    n.isLeaf  = false;
    n.edgeLbl = edgeLbl;
    n.left    = left;
    n.right   = right;
    return n;
}

TreeNode leaf(int cls, string edgeLbl) {
    TreeNode n = new TreeNode;
    n.isLeaf    = true;
    n.leafClass = cls;
    n.edgeLbl   = edgeLbl;
    return n;
}

// --- Style
real ySep      = 2.4;   // vertical distance between levels
real hStart    = 3.0;   // initial horizontal offset (halves at each level) -- wider than
                         // supervised_tree.asy since the split labels here are longer
real treeR     = r;     // leaf circle radius — same as scatter plot points
real nodePad   = 0.15;  // padding around label text inside internal node boxes
// IMPORTANT: unitScale must equal the unitsize() set in supervised_common.asy
real unitScale = 1.3cm; // converts PostScript points (frame coords) to user units
real lblOff    = 0.32;  // horizontal nudge to keep edge labels off the edge line

pen nodepen = fg + linewidth(0.8pt);
pen edgepen = fg + linewidth(0.7pt);

// --- Drawing helpers (identical to supervised_tree.asy)

pair nodeExtents(string cond) {
    frame f;
    label(f, cond);
    pair sz = max(f) - min(f);
    return (sz.x/(2*unitScale) + nodePad, sz.y/(2*unitScale) + nodePad);
}

void drawInternalNode(pair c, string cond, pair ext) {
    filldraw((c+(-ext.x,-ext.y))--(c+(ext.x,-ext.y))
            --(c+(ext.x, ext.y))--(c+(-ext.x, ext.y))--cycle, bg, nodepen);
    label(cond, c, fg);
}

void drawLeafNode(pair c, int cls) {
    if (cls == 1) drawClass1Point(c, treeR, nodepen);
    else          drawClass2Point(c, treeR, nodepen);
}

void drawEdge(pair parentPos, real parentHH,
              pair childPos,  real childHH,
              string lbl, bool leftBranch) {
    pair start = parentPos + (0, -parentHH);
    pair end   = childPos  + (0,  childHH);
    draw(start--end, edgepen, Arrow(5));
    pair mid = (start + end) / 2;
    label(lbl, mid + ((leftBranch ? -lblOff : lblOff), 0), fg);
}

void drawTree(TreeNode node, pair pos, real hOffset) {
    if (node.isLeaf) {
        drawLeafNode(pos, node.leafClass);
    } else {
        pair leftPos  = pos + (-hOffset, -ySep);
        pair rightPos = pos + ( hOffset, -ySep);
        pair ext      = nodeExtents(node.label);
        real leftHH   = node.left.isLeaf  ? treeR : nodeExtents(node.left.label).y;
        real rightHH  = node.right.isLeaf ? treeR : nodeExtents(node.right.label).y;

        drawTree(node.left,  leftPos,  hOffset/2);
        drawTree(node.right, rightPos, hOffset/2);

        drawEdge(pos, ext.y, leftPos,  leftHH,  node.left.edgeLbl,  true);
        drawEdge(pos, ext.y, rightPos, rightHH, node.right.edgeLbl, false);

        drawInternalNode(pos, node.label, ext);
    }
}

// --- Tree definition (matches the leaf regions in supervised_exercise_scatter.asy)
// Note this tree has only 3 leaves, not 4: on the x1>=5 side, practice
// exams no longer separate the classes (both x2<5 and x2>=5 are
// pass-majority there), so a real tree-growing algorithm would not
// introduce that split -- it wouldn't improve purity at all.
TreeNode root =
    internal("hours studied $x_1 <5$", "",
        internal("practice exams $x_2 <3.5$", "yes",
            leaf(1, "yes"),
            leaf(2, "no")),
        leaf(2, "no"));

drawTree(root, (0, 2*ySep), hStart);

shipout(bbox(3mm, Fill(bg)));
