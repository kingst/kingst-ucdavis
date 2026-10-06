"""
Gen-Z translator: a minimal example of calling an LLM through an API.

Each sentence in SENTENCES is sent to Claude with a system prompt that
asks for a Gen-Z rewrite. One sentence in, one request out, one reply
back. See llm_api_basics_overview.md for setup and the ideas behind it.

Run with:  python genz_translate.py
Needs:     creds.py with your API key (copy creds_example.py to make it)
"""

import sys

import anthropic

MODEL = "claude-opus-5-5"

# The system prompt sets the rules for the whole conversation. The user
# message carries the data. Keeping those separate is the single most
# useful habit when working with these APIs.
SYSTEM_PROMPT = """You are a translator from standard English to Gen-Z English.

The user will send one sentence. Rewrite it so it sounds like a Gen-Z
person wrote it: casual tone, current slang, lowercase is fine, emoji
are optional. Keep the original meaning intact.

Reply with only the rewritten sentence, nothing else."""

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


def translate(client: anthropic.Anthropic, sentence: str) -> tuple[str, int, int]:
    """Send one sentence to Claude. Returns (reply, input_tokens, output_tokens)."""
    response = client.messages.create(
        model=MODEL,
        max_tokens=1024,  # a ceiling on the reply length, not a target
        system=SYSTEM_PROMPT,
        messages=[{"role": "user", "content": sentence}],
        # This is a simple task, so ask the model not to think hard about it.
        # Lower effort means a faster and cheaper reply. The default is "medium".
        output_config={"effort": "low"},
    )

    # The reply is a list of content blocks, not a single string. Current
    # models can include a "thinking" block before the "text" block, so
    # never assume response.content[0] is the text.
    if response.stop_reason != "end_turn":
        reply = f"[no translation, stop_reason={response.stop_reason}]"
    else:
        reply = "".join(block.text for block in response.content if block.type == "text")

    return reply.strip(), response.usage.input_tokens, response.usage.output_tokens


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
            reply, input_tokens, output_tokens = translate(client, sentence)
        except anthropic.AuthenticationError:
            print("The API rejected the key. Check the key in creds.py and try again.")
            return 1
        except anthropic.APIConnectionError as error:
            print(f"Could not reach the API: {error}")
            return 1
        except anthropic.APIStatusError as error:
            print(f"API error {error.status_code}: {error.message}")
            return 1

        print(f"gen-z:    {reply}")
        print(f"          ({input_tokens} tokens in, {output_tokens} tokens out)")
        print()
        total_input += input_tokens
        total_output += output_tokens

    cost = (total_input * PRICE_PER_MTOK_INPUT + total_output * PRICE_PER_MTOK_OUTPUT) / 1_000_000
    print(f"total: {total_input} tokens in, {total_output} tokens out, about ${cost:.4f}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
