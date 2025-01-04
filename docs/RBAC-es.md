## Explicación y Flujo

### 1. **Tabla `Permissions`** (unificada para módulos, secciones y subsecciones):

-   Esta tabla unificada contendrá tanto **módulos** (sin `parentId`) como **secciones** (con `parentId` apuntando al módulo correspondiente) y **subsecciones** (con un `parentId` apuntando a la sección o subsección correspondiente).
-   **Ejemplo**:
    -   **Módulo "Seguridad"**: `parentId = NULL`
    -   **Sección "Usuarios"**: `parentId = ID del Módulo "Seguridad"`
    -   **Subsección "Ver Usuarios"**: `parentId = ID de la sección "Usuarios"`

### 2. **Tabla `Actions`**:

-   Define las posibles acciones sobre los permisos, como:
    -   **"consultar"**
    -   **"crear"**
    -   **"actualizar"**
    -   **"eliminar"**

### 3. **Tabla `CustomPermissions`**:

-   Esta tabla permite asignar permisos personalizados a los **roles** con las **acciones** correspondientes.
-   Ejemplo:
    -   **Rol "Reportes"**: Se asigna el **permiso** de **"Usuarios"** con la **acción** "consultar".
    -   Esto se almacena en la tabla **`CustomPermissions`**:
        -   `roleId`: ID del rol "Reportes"
        -   `permissionId`: ID de "Usuarios"
        -   `actionId`: ID de la acción "consultar"

### 4. **Tabla `UsersRoles`**:

-   Relaciona a los **usuarios** con los **roles** asignados.
-   Un usuario puede tener uno o más roles, y cada rol tiene ciertos permisos y acciones asignados.

---

### Ejemplo de flujo con datos:

#### 1. **Definición de permisos**:

-   **Módulo "Seguridad"**:
    -   ID: 1, `parentId`: NULL, nombre: "Seguridad"
-   **Sección "Usuarios"** (pertenece a "Seguridad"):
    -   ID: 2, `parentId`: 1, nombre: "Usuarios"
-   **Subsección "Ver Usuarios"** (pertenece a "Usuarios"):
    -   ID: 3, `parentId`: 2, nombre: "Ver Usuarios"
-   **Subsección "Crear Usuarios"** (pertenece a "Usuarios"):
    -   ID: 4, `parentId`: 2, nombre: "Crear Usuarios"

#### 2. **Asignación de permisos personalizados a un rol**:

-   **Rol "Reportes"**:
    -   Se asigna el **permiso** de **"Usuarios"** con la **acción** "consultar".
    -   Esto se almacena en la tabla **`CustomPermissions`**:
        -   `roleId`: ID del rol "Reportes"
        -   `permissionId`: ID de "Usuarios"
        -   `actionId`: ID de la acción "consultar"

#### 3. **Vinculación de usuarios con roles**:

-   Un **usuario** se asigna al **rol "Reportes"** en la tabla **`UsersRoles`**.

---

### Beneficios:

-   **Jerarquía flexible** para organizar módulos, secciones y subsecciones de manera estructurada.
-   **Acciones personalizables**: Cada rol puede tener permisos personalizados con acciones específicas.
-   **Escalabilidad**: La estructura soporta la adición de nuevos módulos, secciones y permisos sin modificaciones estructurales.

### Conclusión:

La estructura proporcionada permite gestionar un sistema de **RBAC** flexible y escalable, donde los roles pueden ser asignados con permisos personalizados y acciones definidas para cada módulo y sección de la aplicación.
