Objective: Control communication between pods to ensure only authorized traffic flows.

Implementation:

Defined a NetworkPolicy to allow traffic only from specific pods or namespaces.
Ensure the Kubernetes CNI plugin supports network policies



Explanation:
This policy allows only pods with the label app: allowed-app to communicate with the fastapi application on port 80.
All other traffic is denied by default.


Explanation:
This policy allows only pods with the label app: allowed-app to communicate with the fastapi application on port 80.
All other traffic is denied by default.