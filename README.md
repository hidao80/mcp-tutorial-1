[![MseeP.ai Security Assessment Badge](https://mseep.net/pr/hidao80-mcp-tutorial-1-badge.png)](https://mseep.ai/app/hidao80-mcp-tutorial-1)

# SQLite MCP Server Tutorial (1)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This is the first tutorial for a Model Context Protocol (MCP) server for operating SQLite databases. Can be used with Cursor editor and other MCP-compatible clients.

## Features

- SQLite database read/write operations
- SQL query execution
- Table creation, deletion, and modification
- Data insertion, updating, and deletion
- Schema inspection

## Characteristics

- **Zero configuration**: Start using immediately without additional setup
- **Complete SQL operation support**: Full CRUD (Create, Read, Update, Delete) operations
- **Cross-platform**: Windows, macOS, Linux support

## Setup

### 1. Database Initialization

If you need initial data, run `init.sql` using SQLite commands or a DB browser:

#### If SQLite3 is installed

```sh
# For bash, command prompt, zsh
sqlite3 database.db < init.sql

# For PowerShell
Get-Content .\init.sql | sqlite3.exe .\database.db
```

### 2. MCP Server Runtime Environment Installation

This repository uses `uvx`, so `uv` installation is required in advance.

```sh
# macOS
brew install uv

# Windows 11
winget install --id=astral-sh.uv
```

## 3. MCP Configuration File Placement

**For Cursor**: `.cursor/mcp.json`
**For VS Code**: `.vscode/mcp.json`
**For Windsurf**: `.windsurf/mcp.json`

This project places `./.cursor/mcp.json`, `./.vscode/mcp.json`, and `./.windsurf/mcp.json`,
so they will be automatically recognized when the project is opened.

## 4. Setup Instructions

### For Cursor

1. Clone or download this repository
2. Open this repository directory in Cursor
3. Press `Shift + Ctrl + P` (Windows/Linux) `Cmd + Shift + P` (MacBook) to
   open the command palette
4. Type `openmcp` and open the "Tools & Integrations" tab
5. Turn on the "sqlite" MCP server switch (green) from the "MCP Tools" section

### For VS Code

1. Clone or download this repository
2. Open this repository directory in VS Code
3. Press `Shift + Ctrl + P` (Windows/Linux) `Cmd + Shift + P` (MacBook) to
   open the command palette
4. Type `mcpli` and select "MCP: List Servers"
5. Select "sqlite stopped" from the command palette and start it

### For Windsurf

1. Clone or download this repository
2. Open this repository directory in Windsurf
3. Press `Shift + Ctrl + P` (Windows/Linux) `Cmd + Shift + P` (MacBook) to
   open the command palette
4. Type `mcpli` and select "MCP: List Servers"
5. Select "sqlite stopped" from the command palette and start it

### Usage with Claude Desktop

To use MCP servers with Claude Desktop, build and install a DXT (Desktop Extensions) package.

The steps to build a DXT package for Claude Desktop are as follows:

```sh
# Common for bash, command prompt, PowerShell, zsh
# Navigate to dxt directory and build
cd dxt-src
npm run package

# Only PowerShell Commands Are Different
npm run package-ps
```

When the build succeeds, the `dist/sqlite-mcp-server.dxt` file will be generated.

### Required Dependencies

Building the DXT package requires:

- Node.js 18 or higher
- Official DXT CLI (automatically installed when running npm run build)

### Installation in Claude Desktop

1. Build the DXT package using the above steps
2. Drag and drop the generated `.dxt` file to Claude Desktop's Settings > Extensions screen
3. Give the database file path to "SQLite MCP Server" and turn on the "Enabled" switch (blue)
4. If the database file exists at the specified location, the SQLite MCP server will become available

## Troubleshooting

### When MCP Server Fails to Start

1. Confirm `uv` is installed
2. Check internet connection (required for `uvx` to download packages)
3. Verify the database file exists as `database.db` in the project root

### When Database File Cannot Be Found

1. Check write permissions for project directory
2. Run `init.sql` with `sqlite3` to create the database
3. Verify the database file path is correctly set in `mcp.json` or "SQLite MCP Server" DXT

## File Structure

```plaintext
mcp-tutorial-1/
├── init_ja.sql               # Initial database schema and sample data (Japanese version)
├── init.sql                  # Initial database schema and sample data (English version)
├── README.md                 # This file
├── database.db               # SQLite database file (created during initialization)
├── .gitignore                # Git exclusion settings
├── .cursor/mcp.json          # MCP configuration file (for Cursor)
├── .vscode/mcp.json          # MCP configuration file (for VS Code)
├── .windsurf/mcp.json        # MCP configuration file (for Windsurf)
├── docs/                     # Design documentation files
│   ├── DESIGN_ja.md          # Design document (Japanese)
│   └── DESIGN.md             # Design document (English)
├── dxt-src/                  # DXT files for Claude Desktop
│   ├── manifest.json         # DXT manifest file
│   ├── icon.png              # DXT icon image
│   ├── index.js              # DXT main entry point
│   ├── package.json          # Package configuration for DXT
│   ├── README_ja.md          # DXT-specific documentation (Japanese)
│   └── README.md             # DXT-specific documentation (English)
└── dist/                     # Build artifacts (.dxt files)
    └── sqlite-mcp-server.dxt # Desktop extension for Claude Desktop
```

## License

This project is released under the MIT License. See the [LICENSE](LICENSE) file for details.
