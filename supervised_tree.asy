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
real ySep   = 2.4;   // vertical distance between levels
real hStart = 2.5;   // initial horizontal offset (halves at each level)

real nW    = 1.6;    // internal node half-width
real nH    = 0.42;   // internal node half-height
real treeR = 0.55;   // leaf circle radius (larger than scatter plot points)

real lblOff = 0.32;  // horizontal nudge to keep edge labels off the edge line

pen nodepen = fg + linewidth(0.8pt);
pen edgepen = fg + linewidth(0.7pt);

// --- Drawing helpers
path intBox(pair c) {
    return (c+(-nW,-nH))--(c+(nW,-nH))--(c+(nW,nH))--(c+(-nW,nH))--cycle;
}

void drawInternalNode(pair c, string cond) {
    filldraw(intBox(c), bg, nodepen);
    label(cond, c, fg);
}

// Leaf style matches class point style from scatter plots, scaled up.
void drawLeafNode(pair c, int cls) {
    if (cls == 1) {
        filldraw(circle(c, treeR), bg, nodepen);
        label("$1$", c, fg);
    } else {
        filldraw(circle(c, treeR), fg, nodepen);
        label("$2$", c, bg);
    }
}

// Draw a directed edge from the bottom of an internal node at `from`
// to the top of a child node at `to`, with a branch label.
void drawEdge(pair parentPos, pair childPos, bool toLeaf, string lbl, bool leftBranch) {
    pair start = parentPos + (0, -nH);
    pair end   = childPos  + (0, toLeaf ? treeR : nH);
    draw(start--end, edgepen, Arrow(5));
    pair mid = (start + end) / 2;
    label(lbl, mid + ((leftBranch ? -lblOff : lblOff), 0), fg);
}

// Recursively draw the subtree rooted at `node`, centred at `pos`.
// `hOffset` is the horizontal distance from this node to each child;
// it halves at every level, giving a balanced layout for a complete binary tree.
// Draw order: children first, then edges, then this node — so each node's
// filled rectangle/circle covers the edge endpoints cleanly.
void drawTree(TreeNode node, pair pos, real hOffset) {
    if (node.isLeaf) {
        drawLeafNode(pos, node.leafClass);
    } else {
        pair leftPos  = pos + (-hOffset, -ySep);
        pair rightPos = pos + ( hOffset, -ySep);

        drawTree(node.left,  leftPos,  hOffset/2);
        drawTree(node.right, rightPos, hOffset/2);

        drawEdge(pos, leftPos,  node.left.isLeaf,  node.left.edgeLbl,  true);
        drawEdge(pos, rightPos, node.right.isLeaf, node.right.edgeLbl, false);

        drawInternalNode(pos, node.label);
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
