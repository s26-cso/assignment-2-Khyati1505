#include <stdio.h>
#include <stdlib.h>

struct Node {
    int val;
    struct Node* left;
    struct Node* right;
};

// Function declarations (implemented in q1.s)
extern struct Node* make_node(int val);
extern struct Node* insert(struct Node* root, int val);
extern struct Node* get(struct Node* root, int val);
extern int getAtMost(int val, struct Node* root);

// Helper function to print inorder (for testing)
void inorder(struct Node* root) {
    if (root == NULL) return;
    inorder(root->left);
    printf("%d ", root->val);
    inorder(root->right);
}

int main() {
    struct Node* root = NULL;

    // Insert in random-ish order to get a balanced-ish tree
    int vals[] = {50, 25, 75, 10, 35, 60, 90, 5, 15, 30, 45};
    int n = sizeof(vals) / sizeof(vals[0]);

    for (int i = 0; i < n; i++)
        root = insert(root, vals[i]);

    printf("Inorder: ");
    inorder(root);
    printf("\n"); // expect sorted order

    // getAtMost tests
    printf("getAtMost(0): %d\n",   getAtMost(0, root));   // -1
    printf("getAtMost(5): %d\n",   getAtMost(5, root));   // 5
    printf("getAtMost(7): %d\n",   getAtMost(7, root));   // 5
    printf("getAtMost(45): %d\n",  getAtMost(45, root));  // 45
    printf("getAtMost(46): %d\n",  getAtMost(46, root));  // 45
    printf("getAtMost(100): %d\n", getAtMost(100, root)); // 90

    return 0;
}