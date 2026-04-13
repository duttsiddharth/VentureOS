import { withAuth } from 'next-auth/middleware'
import { NextResponse } from 'next/server'

export default withAuth(
  function middleware(req) {
    return NextResponse.next()
  },
  {
    callbacks: {
      authorized: ({ token }) => !!token,
    },
  }
)

// Protect these routes — redirect unauthenticated users to sign-in
export const config = {
  matcher: ['/dashboard/:path*', '/history/:path*', '/api/analyze', '/api/history/:path*', '/api/stripe/portal'],
}
