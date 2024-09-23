import { describe, expect, it } from "vitest";
import app from "../../app";

describe("Leagues Controller", () => {
  it("200: returns an array of leagues", async () => {
    const res = await app.request("api/v1/leagues");
    const data = await res.json();

    expect(res.status).toStrictEqual(200);
    expect(Array.isArray(data)).toStrictEqual(true);
  });

  it("500: returns an empty array and error message", { todo: true });
});
