# Base Symphony JS - SQL

## Author

**[Luis Solano](https://www.linkedin.com/in/luis-fernando-solano/)**

-   **Email:** luisfer.sm15@gmail.com
-   **GitHub:** [XxLuisFer15xX](https://github.com/XxLuisFer15xX)

## License

This project is licensed under the [MIT License](LICENSE).

## Previous Configurations

### Essential tools

1. Install [Visual Studio Code](https://code.visualstudio.com/).
2. Install [SQL Server Express Edition](https://www.microsoft.com/es-es/download/details.aspx?id=101064).
3. Install [SQL Server Management Studio](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver16).

## File Structure

1. **docs:** RBAC system documentation.
2. **env/(environment):** Folder containing environment variables for different environments.
3. **src/(schema)**
    - **ddl:** Scripts for creating and deleting tables.
    - **dml:** Scripts for inserting and clearing tables.
    - **functions:** Scripts for creating functions.
    - **model:** Relational model of the database.
    - **sp:** Scripts for creating stored procedures.
    - **triggers:** Scripts for creating triggers.
    - **views:** Scripts for creating views.
4. **.editorconfig:** File for indentation configuration of the files.
5. **.env:** File containing the environment variables for the project.
6. **.env.example:** File containing an example of the environment variables for the project.
7. **.gitignore:** File describing which files will be ignored by git.
8. **generate-environment-credentials.sh:** Script for loading environment variables.
9. **LICENSE:** Project license.
10. **README.md:** File containing general project information.
11. **RUN_example_dbo.sh:** Example script for creating a database with the dbo schema (not required to be used).
12. **RUN.sh:** Master script that manages the execution of SQL scripts.

## Steps to follow

1. Clone the project.
2. Open a git bash console or shell.
3. Run `sh generate-environment-credentials.sh local` to load the **local environment** variables.
4. Run `sh generate-environment-credentials.sh dev` to load the **development** environment variables.
5. Run `sh generate-environment-credentials.sh qa` to load the **qa environment** variables.
6. Run `sh generate-environment-credentials.sh prod` to load the **production environment** variables.
7. Run `sh RUN.sh` and follow the instructions on the console.
