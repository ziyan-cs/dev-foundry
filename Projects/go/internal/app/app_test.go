package app

import "testing"

func TestGreeting(t *testing.T) {
	t.Parallel()

	if got, want := Greeting(), "ready"; got != want {
		t.Errorf("Greeting() = %q, want %q", got, want)
	}
}
