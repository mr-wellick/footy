import { describe, it } from "node:test";
import assert from "node:assert";
import app from "../../app";

describe("Teams Controller", async () => {
  it("200: should return a view for teams, whether epmty or not.", async () => {
    const res = await app.request("/api/v1/teams", {
      method: "POST",
      body: new URLSearchParams({
        league_id: "81fd5d4e-d500-413f-881d-6ec5cd2d5222",
      }).toString(),
      headers: new Headers({
        "Content-Type": "application/x-www-form-urlencoded",
      }),
    });

    assert.strictEqual(200, res.status);
  });

  it("404: should return a zod error object", async () => {
    const res = await app.request("/api/v1/teams");

    assert.strictEqual(404, res.status);
  });

  it("500: should return an error view when db query fails", { todo: true });
});
