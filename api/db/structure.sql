SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: games; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.games (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    cover_image character varying,
    physical boolean DEFAULT false,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: games_tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.games_tags (
    game_id bigint,
    tag_id bigint
);


--
-- Name: leagues; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.leagues (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying NOT NULL,
    "desc" text,
    cover_image character varying,
    rated boolean DEFAULT true,
    public boolean DEFAULT false,
    official boolean DEFAULT false,
    game_id uuid NOT NULL,
    match_type_id uuid,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: leagues_tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.leagues_tags (
    id bigint NOT NULL,
    league_id bigint,
    tag_id bigint
);


--
-- Name: leagues_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.leagues_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: leagues_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.leagues_tags_id_seq OWNED BY public.leagues_tags.id;


--
-- Name: match_players; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.match_players (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    start_rating integer,
    end_rating integer,
    match_team_id uuid,
    player_id uuid,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: match_teams; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.match_teams (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    outcome integer,
    avg_rating integer NOT NULL,
    match_id uuid,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: match_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.match_types (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    team_size integer NOT NULL,
    team_count integer NOT NULL,
    game_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: matches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.matches (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    started_at date,
    ended_at date,
    state character varying,
    match_type_id uuid NOT NULL,
    league_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: players; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.players (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    username character varying NOT NULL,
    rating integer,
    user_id uuid,
    game_id uuid NOT NULL,
    league_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tags (
    id bigint NOT NULL,
    name character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    username character varying NOT NULL,
    email character varying NOT NULL,
    avatar character varying,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    validation_dud character varying DEFAULT 'virgin-validation-dud'::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: leagues_tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leagues_tags ALTER COLUMN id SET DEFAULT nextval('public.leagues_tags_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: games games_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.games
    ADD CONSTRAINT games_pkey PRIMARY KEY (id);


--
-- Name: leagues leagues_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leagues
    ADD CONSTRAINT leagues_pkey PRIMARY KEY (id);


--
-- Name: leagues_tags leagues_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leagues_tags
    ADD CONSTRAINT leagues_tags_pkey PRIMARY KEY (id);


--
-- Name: match_players match_players_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.match_players
    ADD CONSTRAINT match_players_pkey PRIMARY KEY (id);


--
-- Name: match_teams match_teams_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.match_teams
    ADD CONSTRAINT match_teams_pkey PRIMARY KEY (id);


--
-- Name: match_types match_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.match_types
    ADD CONSTRAINT match_types_pkey PRIMARY KEY (id);


--
-- Name: matches matches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_pkey PRIMARY KEY (id);


--
-- Name: players players_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.players
    ADD CONSTRAINT players_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_games_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_games_on_slug ON public.games USING btree (slug);


--
-- Name: index_games_tags_on_game_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_games_tags_on_game_id ON public.games_tags USING btree (game_id);


--
-- Name: index_games_tags_on_tag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_games_tags_on_tag_id ON public.games_tags USING btree (tag_id);


--
-- Name: index_leagues_on_game_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_leagues_on_game_id ON public.leagues USING btree (game_id);


--
-- Name: index_leagues_on_match_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_leagues_on_match_type_id ON public.leagues USING btree (match_type_id);


--
-- Name: index_leagues_tags_on_league_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_leagues_tags_on_league_id ON public.leagues_tags USING btree (league_id);


--
-- Name: index_leagues_tags_on_tag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_leagues_tags_on_tag_id ON public.leagues_tags USING btree (tag_id);


--
-- Name: index_match_players_on_match_team_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_match_players_on_match_team_id ON public.match_players USING btree (match_team_id);


--
-- Name: index_match_players_on_player_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_match_players_on_player_id ON public.match_players USING btree (player_id);


--
-- Name: index_match_teams_on_match_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_match_teams_on_match_id ON public.match_teams USING btree (match_id);


--
-- Name: index_match_types_on_game_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_match_types_on_game_id ON public.match_types USING btree (game_id);


--
-- Name: index_matches_on_league_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_matches_on_league_id ON public.matches USING btree (league_id);


--
-- Name: index_matches_on_match_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_matches_on_match_type_id ON public.matches USING btree (match_type_id);


--
-- Name: index_players_on_game_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_players_on_game_id ON public.players USING btree (game_id);


--
-- Name: index_players_on_league_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_players_on_league_id ON public.players USING btree (league_id);


--
-- Name: index_players_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_players_on_user_id ON public.players USING btree (user_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20210807081945'),
('20210807081946'),
('20210807081947'),
('20210807081948'),
('20210807081949'),
('20210807140822'),
('20210807140823'),
('20210807140824'),
('20210807142311'),
('20220115114727');


