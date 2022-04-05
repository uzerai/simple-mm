import PlayerTable from "./components/PlayerTable";
import Games from "./pages/Games";
import Home from "./pages/Home";
import League from "./pages/League";
import Leagues from "./pages/Leagues";
import Login from "./pages/Login";
import Match from "./pages/Match";
import Signup from "./pages/Signup";

// Any route which has a displayName will be displayed in the main navigation menu header.
export default [
  {
    path: "/",
    component: Home,
    name: "home",
    displayName: "Home",
    meta: {
      title: "Home",
      public: true,
    },
  },
  { path: "/players", component: PlayerTable },
  { path: "/games", component: Games, displayName: "Games", name: "games", 
    meta: {
      title: "Games"
    } 
  },
  { path: "/games/:slug/leagues", component: Leagues, props: true, name: "game-leagues", meta: { title: "Leagues | :slug" } },
  { path: "/leagues/:league_id", component: League, props: true, name: "league", meta: { title: "Leagues | :league_id"} },
  { path: "/match/:match_id", component: Match, props: true, name: "match" },
  {
    path: "/login",
    component: Login,
    name: "login",
    meta: {
      title: "Login",
      public: true,
    },
  },
  {
    path: "/signup",
    component: Signup,
    name: "signup",
    meta: {
      title: "Sign up!",
      public: true,
    },
  },
];
