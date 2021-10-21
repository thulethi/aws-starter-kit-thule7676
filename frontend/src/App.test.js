import { render, screen } from '@testing-library/react';
import App from './App';

test('contains send message header', () => {
  render(<App />);
  const linkElement = screen.getByText(/send message/i);
  expect(linkElement).toBeInTheDocument();
});

test('contains submit button', () => {
  render(<App />);
  const linkElement = screen.getByText(/submit/i);
  expect(linkElement).toBeInTheDocument();
});
