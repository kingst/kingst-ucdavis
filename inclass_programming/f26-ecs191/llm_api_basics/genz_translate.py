"""
Gen-Z translator: a minimal example of calling an LLM through an API.

Each sentence in SENTENCES is sent to Claude with a system prompt that
asks for a Gen-Z rewrite. One sentence in, one request out, one JSON
reply back. See llm_api_basics_overview.md for setup and the ideas
behind it.

Run with:  python genz_translate.py
Needs:     creds.py with your API key (copy creds_example.py to make it)
"""

import json
import sys

import anthropic
from anthropic.types import Message

MODEL = "claude-opus-5-5"

# The system prompt sets the rules for the whole conversation. The user
# message carries the data. Keeping those separate is the single most
# useful habit when working with these APIs.
SYSTEM_PROMPT = """You are a translator from standard English to Gen-Z English.

The user will send one sentence. Rewrite it so it sounds like a Gen-Z
person wrote it: casual tone, current slang, lowercase is fine, emoji
are optional. Keep the original meaning intact."""

# The shape of the JSON we want back, written as a JSON schema. The API
# constrains the reply to match it, so every field listed as required is
# always present and nothing else is. Structured output requires
# "additionalProperties": False on every object.
TRANSLATION_SCHEMA = {
    "type": "object",
    "properties": {
        "translation": {"type": "string"},
    },
    "required": ["translation"],
    "additionalProperties": False,
}

SENTENCES = [
    "I am very tired today and would prefer not to attend the meeting.",
    "That restaurant was excellent; the food exceeded my expectations.",
    "Please remember to submit your assignment before the deadline.",
    "I find this lecture on operating systems genuinely fascinating.",
    "My phone battery died, so I could not respond to your message.",
]

# Price per million tokens for claude-opus-5-5 (input, output), for the
# running cost estimate printed at the end.
PRICE_PER_MTOK_INPUT = 4.00
PRICE_PER_MTOK_OUTPUT = 20.00


def translate(client: anthropic.Anthropic, sentence: str) -> Message:
    """Send one sentence to Claude and return the full response."""
    return client.messages.create(
        model=MODEL,
        max_tokens=1024,  # a ceiling on the reply length, not a target
        system=SYSTEM_PROMPT,
        messages=[{"role": "user", "content": sentence}],
        output_config={
            # Ask for JSON matching TRANSLATION_SCHEMA. The reply's text block
            # is then guaranteed to be valid JSON of exactly that shape.
            "format": {"type": "json_schema", "schema": TRANSLATION_SCHEMA},
            # This is a simple task, so ask the model not to think hard about
            # it. Lower effort means a faster and cheaper reply. The default
            # is "medium".
            "effort": "low",
        },
    )


def main() -> int:
    # The key lives in creds.py, which is gitignored so it never ends up
    # in the repo. creds_example.py shows the shape; copy it and fill it in.
    try:
        from creds import ANTHROPIC_API_KEY
    except ImportError:
        print("creds.py not found. Copy creds_example.py to creds.py and paste your key in.")
        return 1
    if not ANTHROPIC_API_KEY:
        print("ANTHROPIC_API_KEY in creds.py is empty. Paste your key there and run again.")
        return 1

    client = anthropic.Anthropic(api_key=ANTHROPIC_API_KEY)

    total_input = 0
    total_output = 0

    for sentence in SENTENCES:
        print(f"original: {sentence}")
        try:
            response = translate(client, sentence)
        except anthropic.AuthenticationError:
            print("The API rejected the key. Check the key in creds.py and try again.")
            return 1
        except anthropic.APIConnectionError as error:
            print(f"Could not reach the API: {error}")
            return 1
        except anthropic.APIStatusError as error:
            print(f"API error {error.status_code}: {error.message}")
            return 1

        # The reply is a list of content blocks, not a single string. Current
        # models can include a "thinking" block before the "text" block, so
        # never assume response.content[0] is the text. The text is raw JSON.
        raw_json = "".join(block.text for block in response.content if block.type == "text")
        print(f"json:     {raw_json}")

        # Only parse if the model finished cleanly. If it hit max_tokens or
        # refused, the text may be empty or cut off in the middle of the JSON.
        if response.stop_reason != "end_turn":
            print(f"          [no translation, stop_reason={response.stop_reason}]")
        else:
            # json.loads turns the text into a plain dict. The schema
            # guarantees the key exists, so indexing it directly is safe.
            result = json.loads(raw_json)
            print(f"gen-z:    {result['translation']}")

        input_tokens = response.usage.input_tokens
        output_tokens = response.usage.output_tokens
        print(f"          ({input_tokens} tokens in, {output_tokens} tokens out)")
        print()
        total_input += input_tokens
        total_output += output_tokens

    cost = (total_input * PRICE_PER_MTOK_INPUT + total_output * PRICE_PER_MTOK_OUTPUT) / 1_000_000
    print(f"total: {total_input} tokens in, {total_output} tokens out, about ${cost:.4f}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
