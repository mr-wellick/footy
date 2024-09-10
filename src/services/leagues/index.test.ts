import { describe, it } from "node:test";
import app from "../../index";
import assert from "node:assert";

describe("leagues controller", () => {
  it("200 status code: return drop down with all available leagues, if any ", async () => {
    const res = await app.request("api/v1/leagues");

    assert.strictEqual(200, res.status);
  });
});

// figure out how to test this
//describe("leagues controller", () => {
//  it("500 status code: return error view", async () => {
//    const res = await app.request("api/v1/leagues");
//    assert.strictEqual(500, res.status);
//  });
//});
