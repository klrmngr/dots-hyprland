import QtQuick

ApiStrategy {
    property string lastUserMessage: ""

    function buildEndpoint(model) { return "" }

    function buildRequestData(model, messages, systemPrompt, temperature, tools, filePath) {
        const userMessages = messages.filter(m => m.role === "user");
        if (userMessages.length > 0) {
            lastUserMessage = userMessages[userMessages.length - 1].rawContent;
        }
        return {};
    }

    function buildAuthorizationHeader(apiKeyEnvVarName) { return "" }

    function parseResponseLine(line, message) {
        message.content += line + "\n";
        message.rawContent += line + "\n";
        return {};
    }

    function finalizeScriptContent(scriptContent) {
        const escapedMsg = lastUserMessage.replace(/'/g, "'\\''");
        return `#!/usr/bin/env bash
WORKDIR="/tmp/quickshell/ai/claude-code"
mkdir -p "$WORKDIR"
cd "$WORKDIR"
printf '%s' '${escapedMsg}' | claude --print --output-format text --continue --tools "" 2>/dev/null
`;
    }

    function reset() {
        lastUserMessage = "";
    }
}
