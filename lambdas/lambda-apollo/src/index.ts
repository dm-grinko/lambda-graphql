import { ApolloServer } from "apollo-server-lambda";
import { jsonToGraphQLQuery } from 'json-to-graphql-query';
import { ApolloServerPluginLandingPageGraphQLPlayground } from "apollo-server-core";

import { typeDefs } from "./typeDefs.js";
import { resolvers } from "./resolvers.js";

const server = new ApolloServer({
  typeDefs,
  resolvers,
  introspection: true,
  plugins: [ApolloServerPluginLandingPageGraphQLPlayground()]
});

const graphQLHandler = server.createHandler()

exports.handler = (event, context, callback) => {
  context.callbackWaitsForEmptyEventLoop = false;
  // console.log({ event });
  // const { req, args, userdet } = JSON.parse(JSON.stringify(event));
  // console.log({
  //   req,
  //   args,
  //   userdet
  // });
  // req.body = jsonToGraphQLQuery(req.body, { pretty: true });
  // process.env.payload = JSON.stringify({ event });
  // console.log({ new_req: req})
  return graphQLHandler(event, context, callback);
}
