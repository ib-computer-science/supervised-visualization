import supervised_common;

// --- Tree node structure
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
real hStart    = 2.5;   // initial horizontal offset (halves at each level)
real treeR     = r;     // leaf circle radius — same as scatter plot points; font scales to match internal node text
real nodePad   = 0.15;  // padding around label text inside internal node boxes
// IMPORTANT: unitScale must equal the unitsize() set in supervised_common.asy
real unitScale = 1.3cm; // converts PostScript points (frame coords) to user units
real lblOff    = 0.32;  // horizontal nudge to keep edge labels off the edge line

pen nodepen = fg + linewidth(0.8pt);
pen edgepen = fg + linewidth(0.7pt);

// --- Drawing helpers

// Return the half-extents (hw, hh) of an internal node box for the given label.
pair nodeExtents(string cond) {
    frame f;
    label(f, cond);
    pair sz = max(f) - min(f);
    return (sz.x/(2*unitScale) + nodePad, sz.y/(2*unitScale) + nodePad);
}

// Draw an internal node box using pre-computed half-extents ext = (hw, hh).
void drawInternalNode(pair c, string cond, pair ext) {
    filldraw((c+(-ext.x,-ext.y))--(c+(ext.x,-ext.y))
            --(c+(ext.x, ext.y))--(c+(-ext.x, ext.y))--cycle, bg, nodepen);
    label(cond, c, fg);
}

// Leaf nodes use the same class point style as the scatter plots.
void drawLeafNode(pair c, int cls) {
    if (cls == 1) drawClass1Point(c, treeR, nodepen);
    else          drawClass2Point(c, treeR, nodepen);
}

// Draw a directed edge from the bottom of a parent node to the top of a child.
// childHH is the upward offset from child centre to the edge endpoint:
// treeR for leaf children, nodeExtents(...).y for internal children.
void drawEdge(pair parentPos, real parentHH,
              pair childPos,  real childHH,
              string lbl, bool leftBranch) {
    pair start = parentPos + (0, -parentHH);
    pair end   = childPos  + (0,  childHH);
    draw(start--end, edgepen, Arrow(5));
    pair mid = (start + end) / 2;
    label(lbl, mid + ((leftBranch ? -lblOff : lblOff), 0), fg);
}

// Recursively draw the subtree rooted at `node`, centred at `pos`.
// `hOffset` is the horizontal distance from this node to each child;
// it halves at every level, giving a balanced layout for a complete binary tree.
// Draw order: children first, then edges, then this node — so each node's
// filled shape covers the edge endpoints cleanly.
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

// --- Tree definition (matches decision boundaries in supervised_dtree.asy)
TreeNode root =
    internal("$x_1 < 5$", "",
        internal("$x_2 < 3.5$", "yes",
            leaf(1, "yes"),
            leaf(2, "no")),
        internal("$x_2 < 5$", "no",
            leaf(2, "yes"),
            leaf(1, "no")));

drawTree(root, (0, 2*ySep), hStart);

shipout(bbox(3mm, Fill(bg)));
