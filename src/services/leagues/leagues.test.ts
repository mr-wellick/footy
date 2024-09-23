import { describe, it } from "node:test";
import assert from "node:assert";
import app from "../../app";

describe("Leagues Controller", () => {
  it("200: returns an array of leagues", async () => {
    const res = await app.request("api/v1/leagues");
    const data = await res.json();

    assert.strictEqual(200, res.status);
    assert.strictEqual(true, Array.isArray(data));
  });

  it("500: returns an empty array and error message", { todo: true });
});
