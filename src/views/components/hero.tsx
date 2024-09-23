import { FC } from "hono/jsx";

const DataFilter: FC = () => {
  return (
    <div className="flex flex-col">
      <form
        className="join"
        onChange={(e) => {
          if (e.target) {
            let el = e.target as HTMLFormElement;
            console.log(el.ariaLabel);
          }
        }}
      >
        <input
          className="join-item btn"
          type="radio"
          name="options"
          aria-label="Teams"
          checked
        />
        <input
          className="join-item btn"
          type="radio"
          name="options"
          aria-label="Players"
        />
      </form>
      <div className="flex">
        <div class="badge badge-neutral">EPL</div>
        <div class="badge badge-primary">Arsenal</div>
        <div class="badge badge-secondary">2023-2034</div>
      </div>
      <select className="select select-accent w-full max-w-xs">
        <option disabled selected>
          Dark mode or light mode?
        </option>
        <option>Auto</option>
        <option>Dark mode</option>
        <option>Light mode</option>
      </select>
    </div>
  );
};

const Hero: FC = () => {
  return (
    <div className="flex">
      <DataFilter />
      <div className="hero bg-base-200 min-h-screen">
        <div className="hero-content">
          <div>
            <h1 className="text-5xl font-bold">Box Office News!</h1>
            <p className="py-6">
              Provident cupiditate voluptatem et in. Quaerat fugiat ut assumenda
              excepturi exercitationem quasi. In deleniti eaque aut repudiandae
              et a id nisi.
            </p>
            <button className="btn btn-primary">Get Started</button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Hero;
