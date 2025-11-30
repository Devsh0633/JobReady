import re
import base64
import os

def image_to_base64(match):
    alt_text = match.group(1)
    image_path = match.group(2)
    
    # Handle relative paths
    if not os.path.isabs(image_path):
        image_path = os.path.abspath(image_path)
        
    try:
        with open(image_path, "rb") as image_file:
            encoded_string = base64.b64encode(image_file.read()).decode('utf-8')
            ext = os.path.splitext(image_path)[1].lower().replace('.', '')
            if ext == 'jpg': ext = 'jpeg'
            return f'![{alt_text}](data:image/{ext};base64,{encoded_string})'
    except Exception as e:
        print(f"Could not process image {image_path}: {e}")
        return match.group(0) # Return original if failed

def create_html_doc():
    input_file = "WIREFRAMES.md"
    output_file = "JobReady_Wireframes.html"
    
    with open(input_file, "r") as f:
        content = f.read()
        
    # Replace local image links with base64
    # Regex for ![alt](path)
    pattern = r'!\[(.*?)\]\((.*?)\)'
    processed_content = re.sub(pattern, image_to_base64, content)
    
    # Escape backticks for the JS template string
    safe_content = processed_content.replace('`', '\\`').replace('${', '\\${')
    
    html_template = f"""
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JobReady Wireframes</title>
    <script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>
    <style>
        body {{
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            line-height: 1.6;
            color: #333;
            max_width: 900px;
            margin: 0 auto;
            padding: 40px 20px;
            background-color: #f9f9f9;
        }}
        .document {{
            background-color: white;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }}
        img {{
            max_width: 100%;
            height: auto;
            border: 1px solid #ddd;
            border-radius: 4px;
            margin: 20px 0;
            display: block;
        }}
        pre {{
            background-color: #f4f4f4;
            padding: 15px;
            border-radius: 5px;
            overflow-x: auto;
            border: 1px solid #eee;
        }}
        code {{
            font-family: "SFMono-Regular", Consolas, "Liberation Mono", Menlo, Courier, monospace;
            background-color: #f4f4f4;
            padding: 2px 5px;
            border-radius: 3px;
            font-size: 0.9em;
        }}
        pre code {{
            padding: 0;
            background-color: transparent;
        }}
        h1, h2, h3 {{
            color: #2c3e50;
            margin-top: 1.5em;
        }}
        h1 {{ border-bottom: 2px solid #eee; padding-bottom: 10px; }}
        h2 {{ border-bottom: 1px solid #eee; padding-bottom: 5px; }}
        blockquote {{
            border-left: 4px solid #1565C0;
            margin: 0;
            padding-left: 15px;
            color: #555;
            background-color: #f0f7ff;
            padding: 10px 15px;
            border-radius: 0 4px 4px 0;
        }}
        table {{
            border-collapse: collapse;
            width: 100%;
            margin: 20px 0;
        }}
        th, td {{
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }}
        th {{
            background-color: #f4f4f4;
        }}
        .print-btn {{
            position: fixed;
            top: 20px;
            right: 20px;
            background-color: #1565C0;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }}
        @media print {{
            .print-btn {{ display: none; }}
            body {{ background-color: white; padding: 0; }}
            .document {{ box-shadow: none; padding: 0; }}
        }}
    </style>
</head>
<body>
    <button class="print-btn" onclick="window.print()">Save as PDF / Print</button>
    <div class="document" id="content"></div>

    <script>
        const markdownContent = `{safe_content}`;
        document.getElementById('content').innerHTML = marked.parse(markdownContent);
    </script>
</body>
</html>
    """
    
    with open(output_file, "w") as f:
        f.write(html_template)
    
    print(f"Successfully created {output_file}")

if __name__ == "__main__":
    create_html_doc()
