# LLM API basics: a Gen-Z translator

We are writing a small program that takes ordinary English sentences
and asks an LLM to rewrite them the way a Gen-Z person would say them.
The point is not the translation. The point is to see what calling an
LLM over an API actually looks like: a request goes out with some
text, a reply comes back with some text, and you pay by the token.

The project is at: @inclass_programming/f26-ecs191/llm_api_basics/

We use Python and the official Anthropic SDK, which wraps the HTTP
calls to Claude.

## Setup

From this directory:

```
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

Then copy the example credentials file and paste your API key into it:

```
cp creds_example.py creds.py
```

Edit `creds.py` so it holds your key:

```
ANTHROPIC_API_KEY = "sk-ant-..."
```

The key comes from the Anthropic console. `creds.py` is listed in this
directory's `.gitignore`, so it never gets committed; only
`creds_example.py` does. Then run it:

```
python genz_translate.py
```

## What a request looks like

Every call to the model goes through `client.messages.create(...)` with
five pieces:

- `model`: which model answers. We use `claude-opus-5-5`.
- `system`: standing instructions that apply to the whole conversation.
  This is where the persona lives.
- `messages`: the conversation so far. Here it is one user message
  holding the sentence to translate.
- `max_tokens`: a cap on how long the reply can be.
- `output_config`: extra settings on the reply. Here it carries the JSON
  schema the answer must match, plus the effort level.

The reply comes back as a list of content blocks rather than a plain
string. Current models can emit a thinking block before the text
block, so the script picks out the text blocks instead of assuming the
first block is the answer.

## Getting JSON back instead of prose

Free-form text is fine for a chat window, but if your program needs to
do something with the answer you want structured data. The script
defines `TRANSLATION_SCHEMA`, a JSON schema with a single `translation`
field, and passes it as the `format` inside `output_config`. The API
constrains the reply to match that schema, so the text that comes back
is always valid JSON with exactly that field. The script runs it
through `json.loads` and reads it like any other dict. No regexes, no
hoping the model remembered the field name.

The script prints the raw JSON text first, so you can see exactly what
came over the wire before it was parsed.

The reply also carries a `usage` field with the input and output token
counts. The script prints those per sentence and a rough dollar total
at the end, because cost is the thing people forget about until the
bill arrives.

## A second program: calories from a photo

`meal_calories.py` takes a photo on the command line, sends it to the
model, and prints a description of the meal and a calorie estimate. It
reuses the same venv and `creds.py`.

```
python meal_calories.py lunch.jpg
```

Two new ideas on top of the translator. First, a message's content can
be a list of blocks instead of a string, so the request carries an
image block (the file, base64 encoded, with its media type) followed
by a text block asking the question. Second, the JSON schema has a
`contains_food` boolean. The model sets it to false when the photo has
no food in it, and the script turns that into an error and a nonzero
exit code. Letting the model report "this doesn't apply" through a
field in the schema is far more reliable than hoping to spot the
phrase "I don't see any food" in free text.

The calorie number is a guess from a picture. It is a demo of getting
a number out of the model, not nutrition advice.

## Things to try in class

- Change the system prompt. Make it a pirate, a lawyer, or a Victorian
  novelist and run it again.
- Add a sentence to `SENTENCES` that is ambiguous or already in slang
  and see what comes back.
- Change `effort` from `"low"` to `"high"` and compare the output
  tokens and the latency.
- Swap `MODEL` to `claude-sonnet-5-5` and compare cost and quality.
- Delete the `system` argument and put the instructions in the user
  message instead. Does it still work? Why might you keep them apart?
- Add a second property to `TRANSLATION_SCHEMA` (and to its `required`
  list), say a list of the slang terms used with their meanings, and
  tell the model about it in the system prompt. Watch it show up in the
  JSON with no parsing code to write.
- Give `meal_calories.py` a photo of your desk and read the error. Then
  a photo with a small snack in one corner. Where does the model draw
  the line, and does the calorie number change if you crop the photo?
