package example3;

import example3External.B3;

public class A3 {

	public static void main(String[] args) {
		B3 b = new B3();

		b.method(new A3());
	}

	public String toString() {
		this.endPoint();
		return "";
	}

	public void endPoint() {
	}

}
