package example2;

import example2External.B2;

public class A2 {

	public static void main(String[] args) {
		B2 b = new B2();

		b.method(new A2());
	}

	public String toString() {
		this.endPoint();
		return "";
	}

	public void endPoint() {
	}

}
