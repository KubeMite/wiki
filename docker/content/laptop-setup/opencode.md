---
title: 'OpenCode'
draft: false
series: ["Laptop Setup"]
---

This guide details how I configured my laptop in order to work with [OpenCode](https://opencode.ai)

First install OpenCode:

```sh
brew install anomalyco/tap/opencode
```

I personally use Gemini so let's get the Gemini API key:

1. Go to [AI Studio](https://aistudio.google.com/app/api-keys) -> Create API Key.
1. Name it `OpenCode`, and create a new project called OpenCode.
1. Copy the API key
1. Open **OpenCode** -> Type `/connect` -> Google -> Enter API key.
1. Now we can use Gemini as the AI agent for OpenCode.

Then specify safe permissions for OpenCode in `~/.config/opencode/opencode.json`:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "glob": "allow",
    "grep": "allow",
    "lsp": "allow",
    "question": "allow",
    "read": "allow",
    "webfetch": "allow",
    "websearch": "allow",
    "bash": "ask",
    "doom_loop": "ask",
    "edit": "ask",
    "external_directory": "ask",
    "skill": "ask",
    "task": "ask"
  }
}
```

Now we should install Ollama on a remote desktop to run a local LLM model and make OpenCode use it (since Gemini throttles the amount of requests for free tier). I have a windows desktop with an RTX 5080 which I connect to using TailScale.

1. On the Desktop download & install Ollama.
1. Desktop -> Startup Apps -> Enable Ollama.
1. Desktop -> Ollama -> Settings -> set Context length to 32k.
1. Desktop -> Ollama -> Settings -> Enable **Expose Ollama to the network**.
1. Desktop -> PowerShell -> Run `setx OLLAMA_HOST <desktop-tailscale-ip>`, then restart Ollama

1. On the desktop install a model:

    ```sh
    ollama pull qwen2.5-coder:14b
    ```

1. On the laptop configure OpenCode to use a local Ollama model by merging `~/.config/opencode/opencode.json` with the following configuration:

    ```json
    {
      "$schema": "https://opencode.ai/config.json",
      "provider": {
        "ollama": {
          "npm": "@ai-sdk/openai-compatible",
          "name": "Ollama",
          "options": {
            "baseURL": "http://<desktop-tailscale-ip>:11434/v1"
          },
          "models": {
            "qwen2.5-coder:14b": {
              "tool_call": true
            }
          }
        }
      }
    }
    ```

Do note that tools calls (webfetch, bash, etc.) do not work with this setup. Once I figure it out I will update this guide.
