/* --------------------------------------------------------------------------------------------
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 * ------------------------------------------------------------------------------------------ */
"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode = require("vscode");
const child_process_1 = require("child_process");
const shell = require("shelljs");
const vscode_1 = require("vscode");
const vscode_languageclient_1 = require("vscode-languageclient");
const os = require("os");
function testElixirCommand(command) {
    try {
        return child_process_1.execSync(`${command} -e ""`);
    }
    catch (_a) {
        return false;
    }
}
function testElixir() {
    let testResult = testElixirCommand("elixir");
    if (testResult === false) {
        // Try finding elixir in the path directly
        const elixirPath = shell.which("elixir");
        if (elixirPath) {
            testResult = testElixirCommand(elixirPath);
        }
    }
    if (!testResult) {
        vscode.window.showErrorMessage("Failed to run 'elixir' command. ElixirLS will probably fail to launch. Logged PATH to Development Console.");
        console.warn(`Failed to run 'elixir' command. Current process's PATH: ${process.env["PATH"]}`);
        return false;
    }
    else if (testResult.length > 0) {
        vscode.window.showErrorMessage("Running 'elixir' command caused extraneous print to stdout. See VS Code's developer console for details.");
        console.warn("Running 'elixir -e \"\"' printed to stdout:\n" + testResult.toString());
        return false;
    }
    else {
        return true;
    }
}
function activate(context) {
    testElixir();
    detectConflictingExtension("mjmcloug.vscode-elixir");
    detectConflictingExtension("elixir-lsp.elixir-ls");
    // https://github.com/elixir-lsp/vscode-elixir-ls/issues/34
    detectConflictingExtension("sammkj.vscode-elixir-formatter");
    vscode.commands.registerCommand('extension.copyDebugInfo', copyDebugInfo);
    const command = os.platform() == "win32" ? "language_server.bat" : "language_server.sh";
    const serverOpts = {
        command: context.asAbsolutePath("./elixir-ls-release/" + command)
    };
    // If the extension is launched in debug mode then the debug server options are used
    // Otherwise the run options are used
    const serverOptions = {
        run: serverOpts,
        debug: serverOpts
    };
    // Options to control the language client
    const clientOptions = {
        // Register the server for Elixir documents
        documentSelector: [
            { language: "elixir", scheme: "file" },
            { language: "elixir", scheme: "untitled" },
            { language: "eex", scheme: "file" },
            { language: "eex", scheme: "untitled" },
            { language: "html-eex", scheme: "file" },
            { language: "html-eex", scheme: "untitled" }
        ],
        // Don't focus the Output pane on errors because request handler errors are no big deal
        revealOutputChannelOn: vscode_languageclient_1.RevealOutputChannelOn.Never,
        synchronize: {
            // Synchronize the setting section 'elixirLS' to the server
            configurationSection: "elixirLS",
            // Notify the server about file changes to Elixir files contained in the workspace
            fileEvents: [
                vscode_1.workspace.createFileSystemWatcher("**/*.{ex,exs,erl,yrl,xrl,eex,leex}")
            ]
        }
    };
    // Create the language client and start the client.
    exports.languageClient = new vscode_languageclient_1.LanguageClient("elixirLS", // langId
    "ElixirLS", // display name
    serverOptions, clientOptions);
    const disposable = exports.languageClient.start();
    // Push the disposable to the context's subscriptions so that the
    // client can be deactivated on extension deactivation
    context.subscriptions.push(disposable);
}
exports.activate = activate;
function deactivate() {
    if (!exports.languageClient) {
        return undefined;
    }
    return exports.languageClient.stop();
}
exports.deactivate = deactivate;
function detectConflictingExtension(extensionId) {
    const extension = vscode.extensions.getExtension(extensionId);
    if (extension) {
        vscode.window.showErrorMessage('Warning: ' + extensionId + ' is not compatible with ElixirLS, please uninstall ' + extensionId);
    }
}
function copyDebugInfo() {
    const elixirVersion = child_process_1.execSync(`elixir --version`);
    const extension = vscode.extensions.getExtension('jakebecker.elixir-ls');
    const message = `
  * Elixir & Erlang versions (elixir --version): ${elixirVersion}
  * VSCode ElixirLS version: ${extension.packageJSON.version}
  * Operating System Version: ${os.platform()} ${os.release()}
  `;
    vscode.window.showInformationMessage(`Copied to clipboard: ${message}`);
    vscode.env.clipboard.writeText(message);
}
//# sourceMappingURL=extension.js.map