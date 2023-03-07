import { InvokeCommand, LambdaClient, LogType } from '@aws-sdk/client-lambda';

const JsonToArray = (json) => {
	const str = JSON.stringify(json, null, 0);
	const ret = new Uint8Array(str.length);
	for (let i = 0; i < str.length; i++) {
		ret[i] = str.charCodeAt(i);
	}
	return ret
};

const lambdaInvoke = async (params: { query: string, arg?: string}) => {
  const client = new LambdaClient({ region: 'us-east-1' });

  const command = new InvokeCommand({
    FunctionName: process.env.PYTHON_LAMBDA_ARN,
    LogType: LogType.Tail,
    Payload: JsonToArray(params)
  });

  const { Payload } = await client.send(command);
  const result = Buffer.from(Payload).toString();
  const { body } = JSON.parse(result);
  return JSON.parse(body);
};

export const resolvers = {
  Query: {
    books: async () => {
      // const { payload } = process.env;
      // const { event } = JSON.parse(payload);

      return lambdaInvoke({ query: "getAllBooks" });
    },
    book: async (_: any, { author, title }) => {
      let params;

      if (author) {
        params = {
          query: "getBookByAuthor",
          arg: author,
        }
      } else if (title) {
        params = {
          query: "getBookByTitle",
          arg: title
        }
      } else {
        return [];
      }

      return lambdaInvoke(params);
    },
  }
};
