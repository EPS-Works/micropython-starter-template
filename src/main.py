"""Main file. Runs at boot"""
from sdk import Led
from utoml import load

CONFIG = load('config.txt')

def main():
    """Main function"""
    led = Led('LEDGREEN')
    led.blink(times=3)

if __name__ == '__main__':
    main()
