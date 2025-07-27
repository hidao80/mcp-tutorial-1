# SQLite MCP Server DXT Package

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This directory contains the DXT (Desktop Extension) package files for Claude Desktop integration.

## Overview

The DXT package enables easy installation and use of this SQLite MCP server as a native extension within Claude Desktop, providing seamless database operations through the Model Context Protocol.

## File Description

- **manifest.json**: DXT manifest file containing metadata and configuration
- **index.js**: Main entry point for the DXT package
- **package.json**: Node.js package configuration for DXT
- **README_ja.md**: Japanese documentation file
- **README.md**: This English documentation file

## Features

- Zero-configuration SQLite database access
- Seamless integration with Claude Desktop
- Support for all standard SQL operations
- Built-in error handling and logging

## Installation in Claude Desktop

1. Build the DXT package (see README in project root)
2. Copy the generated `.dxt` file to Claude Desktop's extensions directory
3. Restart Claude Desktop
4. SQLite MCP server will be available for use

## Build Instructions

### For bash, Command Prompt, PowerShell, zsh

```sh
# Common for bash, command prompt, PowerShell, zsh
npm run package

# Only PowerShell Commands Are Different
npm run package-ps
```

After building, `../dist/sqlite-mcp-server.dxt` will be generated.

## Usage

After installation, you can:

- Create and manage database tables
- Insert, update, and delete data
- Perform data analysis through SQL operations
- Generate reports and insights

## Database Location

The SQLite database file (`database.db`) is created in the project root directory. It can be initialized using `init.sql` and can be directly manipulated with various DB tools as needed.

## Troubleshooting

If the extension fails to load:

1. Ensure Node.js 18 or higher is installed
2. Verify that Claude Desktop's built-in Node.js is being used
3. Confirm the DXT file was generated correctly
4. Ensure Claude Desktop has filesystem access permissions
5. Check Claude Desktop's extension logs for error messages

## Support

For issues specific to the DXT package, refer to [README.md](../README.md) in the project root. For additional questions or bug reports, please use the repository's Issue feature.

## License

This package is licensed under the MIT License. See the LICENSE file in the project root for details.
