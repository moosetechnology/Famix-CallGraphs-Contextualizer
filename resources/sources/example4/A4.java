package example4;

import example4External.B4;

public class A4 {

	public static void main(String[] args) {
		B4 b = new B4(new A4());

		b.toString();
	}

	public String toString() {
		this.endPoint();
		return "";
	}

	public void endPoint() {
	}

}
