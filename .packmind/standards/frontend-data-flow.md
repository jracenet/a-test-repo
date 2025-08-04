# Frontend data flow

This standard describes the recommended data flow pattern for frontend routes in Packmind codebase.

We use these dependencies:
- [React Router v7](https://reactrouter.com/start/framework/route-module) in framework mode
- [@react-router/fs-routes](https://reactrouter.com/how-to/file-route-conventions) for a file-based routing convention
- [TanStack Query](https://tanstack.com/query/latest) for data querying and caching

## Domain queries
Queries related to a business model are stored in the `domain` folder of the entity

Example for "standard":
```
apps/frontend/src/domains/standards/api/queries/StandardsQueries.ts
```

and for the query allowing to fetch a standard by its id:

```
const GET_STANDARD_BY_ID_QUERY_KEY = 'standard';

// we export options so we can use both in and out useQuery hooks
export const getStandardByIdOptions = (id: StandardId) => ({
  queryKey: [GET_STANDARD_BY_ID_QUERY_KEY, id],
  queryFn: () => standardsGateway.getStandardById(id),
  enabled: !!id,
});

export const useGetStandardByIdQuery = (id: StandardId) => {
  return useQuery(getStandardByIdOptions(id));
};
```

## Fetching data from a route

React Router provide `loader`and `clientLoader` callbacks to handle data fetching. Page will be render when the loader is done doing its job.
As we are using React Router in SPA mode, only `clientLoader` should be used.

Loader receives route params and uses a `queryClient` to fetch or ensure data is available in the cache.


```typescript
// org.$orgSlug._protected.standards.$standardId._index.tsx

export function clientLoader({ params }: { params: { standardId: string } }) {
  const standardData = queryClient.ensureQueryData(
    getStandardByIdOptions(params.standardId as StandardId),
  );
  return standardData;
}
```

## Data Consumption in Route Module

We use `useLoaderData` hook to get the data returned by the loader

```typescript
// org.$orgSlug._protected.standards.$standardId._index.tsx

const standard = useLoaderData();

return <StandardDetails standard={standard} orgSlug={organization.slug} />;
```

## Benefits

- Centralizes data fetching logic in route loaders for better separation of concerns.
- Ensures data is available before rendering, reducing intermediate loading states.
- Promotes reuse of query options

## Rules
* Do things

---

*This standard was automatically generated from version 1.*