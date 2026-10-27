
const http = require("http");
const fs = require("fs");
const path = require("path");

const PORT = process.env.PORT || 3000;

const server = http.createServer((req, res) => {
    if (req.url === "/health") {
        res.writeHead(200, { "Content-Type": "application/json" });
        res.end(JSON.stringify({ status: "healthy" }));
        return;
    }

    if (req.url === "/" && req.method === "GET") {
        const filePath = path.join(__dirname, "public", "index.html");

        fs.readFile(filePath, (error, content) => {
            if (error) {
                res.writeHead(500);
                res.end("Unable to load website");
                return;
            }

            res.writeHead(200, {
                "Content-Type": "text/html; charset=utf-8"
            });
            res.end(content);
        });

        return;
    }

    res.writeHead(404, { "Content-Type": "text/plain" });
    res.end("Not found");
});

server.listen(PORT, "0.0.0.0", () => {
    console.log(`KubeSpace is running on port ${PORT}`);
});
