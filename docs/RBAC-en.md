## Explanation and Flow

### 1. **`Permissions` Table** (unified for modules, sections, and subsections):

-   This unified table will contain both **modules** (without `parentId`) and **sections** (with `parentId` pointing to the corresponding module) and **subsections** (with a `parentId` pointing to the corresponding section or subsection).
-   **Example**:
    -   **Module "Security"**: `parentId = NULL`
    -   **Section "Users"**: `parentId = ID of "Security" module`
    -   **Subsection "View Users"**: `parentId = ID of "Users" section`

### 2. **`Actions` Table**:

-   Defines the possible actions on permissions, such as:
    -   **"consult"**
    -   **"create"**
    -   **"update"**
    -   **"delete"**

### 3. **`CustomPermissions` Table**:

-   This table allows the assignment of **custom permissions** to **roles** with the corresponding **actions**.
-   Example:
    -   **Role "Reports"**: The **permission** "Users" with the **action** "consult".
    -   This is stored in the **`CustomPermissions`** table:
        -   `roleId`: ID of the "Reports" role
        -   `permissionId`: ID of "Users"
        -   `actionId`: ID of the "consult" action

### 4. **`UsersRoles` Table**:

-   Links **users** with **assigned roles**.
-   A user can have one or more roles, and each role has certain permissions and actions assigned.

---

### Example of Flow with Data:

#### 1. **Defining Permissions**:

-   **Module "Security"**:
    -   ID: 1, `parentId`: NULL, name: "Security"
-   **Section "Users"** (belongs to "Security"):
    -   ID: 2, `parentId`: 1, name: "Users"
-   **Subsection "View Users"** (belongs to "Users"):
    -   ID: 3, `parentId`: 2, name: "View Users"
-   **Subsection "Create Users"** (belongs to "Users"):
    -   ID: 4, `parentId`: 2, name: "Create Users"

#### 2. **Assigning Custom Permissions to a Role**:

-   **Role "Reports"**:
    -   The **permission** "Users" with the **action** "consult".
    -   This is stored in the **`CustomPermissions`** table:
        -   `roleId`: ID of the "Reports" role
        -   `permissionId`: ID of "Users"
        -   `actionId`: ID of the "consult" action

#### 3. **Linking Users to Roles**:

-   A **user** is assigned to the **"Reports"** role in the **`UsersRoles`** table.

---

### Benefits:

-   **Flexible Hierarchy**: Organizes modules, sections, and subsections in a structured way.
-   **Customizable Actions**: Each role can have custom permissions with specific actions.
-   **Scalability**: The structure supports adding new modules, sections, and permissions without structural modifications.

### Conclusion:

The provided structure allows you to manage a **RBAC system** that is flexible and scalable, where roles can be assigned with custom permissions and specific actions for each module and section of the application.
