#!/usr/bin/env node

import { spawn } from "child_process";
import path from "path";
import { fileURLToPath } from "url";
import fs from "fs";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

/**
 * Escape path for Windows compatibility
 * @param {string} path Path to escape
 * @returns {string} Escaped path
 */
function escapeWindowsPath(path) {
    if (typeof path !== 'string') return path;
    if (/^[a-zA-Z]:\\/.test(path)) {
        return path.replace(/\\/g, '\\\\');
    }
    return path;
}

/**
 * Main function
 */
async function main() {
    // Get database path from first argument (passed by DXT manifest)
    let dbPath = process.argv[2] || path.join(__dirname, "database.db");
    dbPath = escapeWindowsPath(dbPath);
    
    // Normalize path for cross-platform compatibility
    const normalizedDbPath = path.resolve(path.normalize(dbPath));

    // Create database directory if it doesn't exist
    const dbDir = path.dirname(normalizedDbPath);
    if (!fs.existsSync(dbDir)) {
        console.error(`Creating database directory at: ${dbDir}`);
        fs.mkdirSync(dbDir, { recursive: true });
    }

    // Create database file if it doesn't exist
    if (!fs.existsSync(normalizedDbPath)) {
        console.error(`Creating database file at: ${normalizedDbPath}`);
        fs.writeFileSync(normalizedDbPath, "");
    }

    console.error(`Starting SQLite MCP Server with database: ${normalizedDbPath}`);

    // Start the official mcp-server-sqlite using uvx
    const server = spawn("uvx", ["mcp-server-sqlite", normalizedDbPath], {
        stdio: ["inherit", "inherit", "inherit"],
        env: {
            ...process.env,
            PYTHONPATH: __dirname,
            UV_CACHE_DIR: path.join(__dirname, ".uv-cache")
        },
        // Ensure proper shell handling on Windows
        shell: process.platform === "win32"
    });

    // Handle graceful shutdown
    const handleShutdown = (signal) => {
        console.error(`Received ${signal}, shutting down server...`);
        server.kill("SIGTERM");
        setTimeout(() => {
            server.kill("SIGKILL");
            process.exit(0);
        }, 5000);
    };

    process.on("SIGINT", handleShutdown);
    process.on("SIGTERM", handleShutdown);

    // Handle server process events
    server.on("close", (code, signal) => {
        if (signal) {
            console.error(`Server terminated by signal: ${signal}`);
        } else {
            console.error(`Server exited with code: ${code}`);
        }
        process.exit(code || 0);
    });

    server.on("error", (error) => {
        console.error("Failed to start SQLite MCP Server:", error.message);

        // Provide helpful error messages
        if (error.code === "ENOENT") {
            console.error(`
Error: uvx command not found. Please install uv first:
  
Windows: 
  winget install astral-sh.uv
  
macOS:
  curl -LsSf https://astral.sh/uv/install.sh | sh
  
Linux:
  curl -LsSf https://astral.sh/uv/install.sh | sh

Then restart your terminal and try again.
      `);
        }

        process.exit(1);
    });

    // Log successful start
    setTimeout(() => {
        console.error("SQLite MCP Server started successfully");
    }, 1000);
}

// Run the server
main().catch((error) => {
    console.error("Unhandled error:", error.message);
    process.exit(1);
});