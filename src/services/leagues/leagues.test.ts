import { describe, it } from "node:test";
import assert from "node:assert";
import app from "../../app";

describe("Leagues Controller", () => {
  it("200: return drop down with all available leagues, if any ", async () => {
    const res = await app.request("api/v1/leagues");

    assert.strictEqual(200, res.status);
  });

  it("500: return an error view", { todo: true });
});
