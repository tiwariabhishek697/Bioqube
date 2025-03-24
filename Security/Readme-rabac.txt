Enable RBAC with Least-Privilege Roles
Objective: Restrict access to Kubernetes resources by assigning roles with the minimum required permissions.


Implementation:
Create a Role or ClusterRole with specific permissions.
Bind the role to a ServiceAccount using a RoleBinding or ClusterRoleBinding

Explanation:
The Role grants permissions to list, get, and watch pods and services in the default namespace.
The RoleBinding associates the Role with a ServiceAccount for the application.