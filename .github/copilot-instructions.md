
# What are Copilot Instructions?

`copilot-instructions.md` provides project-specific guidance for AI coding agents (like GitHub Copilot) to be productive in this codebase. It documents architecture, workflows, conventions, and integration points that are not obvious from code alone. This helps AI agents automate tasks, follow best practices, and avoid common mistakes unique to this repository.

# Copilot Instructions for AI Agents

## Project Overview
This repository is a template for quickly bootstrapping new development projects in VS Code. It automates the inclusion of common tools, recommended extensions, and directory structures for a variety of programming languages.

## Architecture & Layout
- **Directory Structure**: Use the `Create Project Layout` VS Code task to generate standard folders: `docs/`, `scripts/`, `cmd/`, `internal/`, `pkg/`, `test/`.
- **Key Files**:
  - `.vscode/tasks.json`: Defines reusable tasks, especially for project scaffolding.
  - `.vscode/extensions.json`: Lists recommended VS Code extensions for linting, formatting, and language support.
  - `.devcontainer/`: Supports development in containers for Linux parity on Windows.
  - `.env.example` and `Makefile` are created by the layout task for environment and build automation.
  - `megalinter-reports/`: Stores output from MegaLinter and other code quality tools.

## Developer Workflows
- **Project Setup**: Run the `Create Project Layout` task from VS Code to scaffold the project structure and essential files. This is the canonical way to initialize a new repo from this template.
- **Linting & Quality**: Use the recommended extensions (see `.vscode/extensions.json`) for linting and formatting. MegaLinter output is stored in `megalinter-reports/`.
- **Dev Containers**: For isolated or Linux-based development, use the Dev Containers extension and open the folder in a container. See `.devcontainer/devcontainer.json` for configuration.
- **MCP Integration**: The `.vscode/mcp.json` file configures Model Context Protocol (MCP) servers, enabling AI tools to automate tasks directly in VS Code.

## Conventions & Patterns
- **Cross-Platform Tasks**: Tasks in `.vscode/tasks.json` are defined for Windows, Linux, and macOS. Always use the VS Code task runner for consistent results.
- **File Exclusions**: `.vscode/settings.json` hides config and report files from the file explorer to reduce clutter.
- **Extension Usage**: Extensions like `bierner.markdown-mermaid` are recommended for enhanced documentation (e.g., embedding Mermaid diagrams in Markdown).


## Integration Points
- **MegaLinter**: Reports are generated in `megalinter-reports/`.
- **Dev Containers**: Integrate with GitHub CLI for authentication when working inside containers.

## Examples
- To scaffold a new project, run the `Create Project Layout` task in VS Code.
- To add Mermaid diagrams, install the `bierner.markdown-mermaid` extension and use standard Markdown syntax.

## References
- See `README.md` for a high-level overview and additional setup notes.


---
For any unclear or missing conventions, review comments in the respective config files or ask for clarification.# Copilot Instructions for AI Agents

## Project Overview
This repository is a template for quickly bootstrapping new development projects in VS Code. It automates the inclusion of common tools, recommended extensions, and directory structures for a variety of programming languages.

## Architecture & Layout
- **Directory Structure**: Use the `Create Project Layout` VS Code task to generate standard folders: `docs/`, `scripts/`, `cmd/`, `internal/`, `pkg/`, `test/`.
- **Key Files**:
  - `.vscode/tasks.json`: Defines reusable tasks, especially for project scaffolding.
  - `.vscode/extensions.json`: Lists recommended VS Code extensions for linting, formatting, and language support.
  - `.devcontainer/`: Supports development in containers for Linux parity on Windows.
  - `.env.example` and `Makefile` are created by the layout task for environment and build automation.
  - `megalinter-reports/`: Stores output from MegaLinter and other code quality tools.

## Developer Workflows
- **Project Setup**: Run the `Create Project Layout` task from VS Code to scaffold the project structure and essential files. This is the canonical way to initialize a new repo from this template.
- **Linting & Quality**: Use the recommended extensions (see `.vscode/extensions.json`) for linting and formatting. MegaLinter output is stored in `megalinter-reports/`.
- **Dev Containers**: For isolated or Linux-based development, use the Dev Containers extension and open the folder in a container. See `.devcontainer/devcontainer.json` for configuration.
- **MCP Integration**: The `.vscode/mcp.json` file configures Model Context Protocol (MCP) servers, enabling AI tools to automate tasks directly in VS Code.

## Conventions & Patterns
- **Cross-Platform Tasks**: Tasks in `.vscode/tasks.json` are defined for Windows, Linux, and macOS. Always use the VS Code task runner for consistent results.
- **File Exclusions**: `.vscode/settings.json` hides config and report files from the file explorer to reduce clutter.
- **Extension Usage**: Extensions like `bierner.markdown-mermaid` are recommended for enhanced documentation (e.g., embedding Mermaid diagrams in Markdown).
- **AI Rules**: Codacy-specific AI rules are in `.github/instructions/codacy.instructions.md` and should be followed for code analysis and MCP integration.

## Integration Points
- **MegaLinter**: Reports are generated in `megalinter-reports/`.
- **Codacy MCP**: See `.github/instructions/codacy.instructions.md` for required post-edit analysis steps.
- **Dev Containers**: Integrate with GitHub CLI for authentication when working inside containers.

## Examples
- To scaffold a new project, run the `Create Project Layout` task in VS Code.
- To add Mermaid diagrams, install the `bierner.markdown-mermaid` extension and use standard Markdown syntax.

## References
- See `README.md` for a high-level overview and additional setup notes.
- See `.github/instructions/codacy.instructions.md` for Codacy and MCP-specific rules.

---
For any unclear or missing conventions, review comments in the respective config files or ask for clarification.
